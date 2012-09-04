Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2IDPEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:04:33 -0400
Received: from mga12.intel.com ([143.182.124.36]:36375 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757132Ab2IDPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:04:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
	<87627ufi2h.fsf@rustcorp.com.au>
	<CAKi4VALezG7VccXJfwvzr2UZrmAjCUp9eZRjGwqq6cWcExNqXA@mail.gmail.com>
Date: Tue, 4 Sep 2012 18:04:12 +0300
Message-ID: <CALLzPKYM33W-6hL-eEuHn886MCovVGanQ6x_F8UTHrgc_WaJpg@mail.gmail.com>
Subject: Re: [RFC] module: signature infrastructure
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Howells <dhowells@redhat.com>,
        zohar@linux.vnet.ibm.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 5:25 PM, Lucas De Marchi
<lucas.de.marchi@gmail.com> wrote:
> Hi Rusty,
>
> On Tue, Sep 4, 2012 at 2:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> OK, I took a look at the module.c parts of David and Dmitry's patchsets,
>> and didn't really like either, but I stole parts of David's to make
>> this.
>>
>> So, here's the module.c part of module signing.  I hope you two got time
>> to discuss the signature format details?  Mimi suggested a scheme where
>> the private key would never be saved on disk (even temporarily), but I
>> didn't see patches.  Frankly it's something we can do later; let's aim
>> at getting the format right for the next merge window.
>>
>> Cheers,
>> Rusty.
>>
>> ---
>> This patch doesn't compile: we need to implement:
>>
>>         int mod_verify_sig(const void *mod, unsigned long modlen,
>>                            const void *sig, unsigned long siglen,
>>                            bool *sig_ok);
>>
>> Also, we need to actually append the signatures during build.
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index ad7e2e5..9b2b8d3 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1582,6 +1582,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                         log everything. Information is printed at KERN_DEBUG
>>                         so loglevel=8 may also need to be specified.
>>
>> +       module.sig_enforce
>> +                       [KNL] When CONFIG_MODULE_SIG is set, this means that
>> +                       modules without (valid) signatures will fail to load.
>> +                       Note that if CONFIG_MODULE_SIG_ENFORCE is set, that
>> +                       is always true, so this option does nothing.
>> +
>>         mousedev.tap_time=
>>                         [MOUSE] Maximum time between finger touching and
>>                         leaving touchpad surface for touch to be considered
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index fbcafe2..7760c6d 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -21,6 +21,9 @@
>>  #include <linux/percpu.h>
>>  #include <asm/module.h>
>>
>> +/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
>> +#define MODULE_SIG_STRING "~Module signature appended~\n"
>> +
>>  /* Not Yet Implemented */
>>  #define MODULE_SUPPORTED_DEVICE(name)
>>
>> @@ -260,6 +263,11 @@ struct module
>>         const unsigned long *unused_gpl_crcs;
>>  #endif
>>
>> +#ifdef CONFIG_MODULE_SIG
>> +       /* Signature was verified. */
>> +       bool sig_ok;
>> +#endif
>> +
>>         /* symbols that will be GPL-only in the near future. */
>>         const struct kernel_symbol *gpl_future_syms;
>>         const unsigned long *gpl_future_crcs;
>> diff --git a/init/Kconfig b/init/Kconfig
>> index af6c7f8..7452e19 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -1585,6 +1585,20 @@ config MODULE_SRCVERSION_ALL
>>           the version).  With this option, such a "srcversion" field
>>           will be created for all modules.  If unsure, say N.
>>
>> +config MODULE_SIG
>> +       bool "Module signature verification"
>> +       depends on MODULES
>> +       help
>> +         Check modules for valid signatures upon load: the signature
>> +         is simply appended to the module. For more information see
>> +         Documentation/module-signing.txt.
>> +
>> +config MODULE_SIG_FORCE
>> +       bool "Require modules to be validly signed"
>> +       depends on MODULE_SIG
>> +       help
>> +         Reject unsigned modules or signed modules for which we don't have a
>> +         key.  Without this, such modules will simply taint the kernel.
>>  endif # MODULES
>>
>>  config INIT_ALL_POSSIBLE
>> diff --git a/kernel/module.c b/kernel/module.c
>> index 4edbd9c..3cbd1a4 100644
>> --- a/kernel/module.c
>> +++ b/kernel/module.c
>> @@ -102,6 +102,43 @@ static LIST_HEAD(modules);
>>  struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
>>  #endif /* CONFIG_KGDB_KDB */
>>
>> +#ifdef CONFIG_MODULE_SIG
>> +#ifdef CONFIG_MODULE_SIG_ENFORCE
>> +static bool sig_enforce = true;
>> +#else
>> +static bool sig_enforce = false;
>> +
>> +static int param_set_bool_enable_only(const char *val,
>> +                                     const struct kernel_param *kp)
>> +{
>> +       int err;
>> +       bool test;
>> +       struct kernel_param dummy_kp = *kp;
>> +
>> +       dummy_kp.arg = &test;
>> +
>> +       err = param_set_bool(val, &dummy_kp);
>> +       if (err)
>> +               return err;
>> +
>> +       /* Don't let them unset it once it's set! */
>> +       if (!test && sig_enforce)
>> +               return -EROFS;
>> +
>> +       if (test)
>> +               sig_enforce = true;
>> +       return 0;
>> +}
>> +
>> +static const struct kernel_param_ops param_ops_bool_enable_only = {
>> +       .set = param_set_bool_enable_only,
>> +       .get = param_get_bool,
>> +};
>> +#define param_check_bool_enable_only param_check_bool
>> +
>> +module_param(sig_enforce, bool_enable_only, 0644);
>> +#endif /* !CONFIG_MODULE_SIG_ENFORCE */
>> +#endif /* CONFIG_MODULE_SIG */
>>
>>  /* Block module loading/unloading? */
>>  int modules_disabled = 0;
>> @@ -136,6 +173,7 @@ struct load_info {
>>         unsigned long symoffs, stroffs;
>>         struct _ddebug *debug;
>>         unsigned int num_debug;
>> +       bool sig_ok;
>>         struct {
>>                 unsigned int sym, str, mod, vers, info, pcpu;
>>         } index;
>> @@ -2399,7 +2437,50 @@ static inline void kmemleak_load_module(const struct module *mod,
>>  }
>>  #endif
>>
>> -/* Sets info->hdr and info->len. */
>> +#ifdef CONFIG_MODULE_SIG
>> +static int module_sig_check(struct load_info *info,
>> +                           void *mod, unsigned long *len)
>> +{
>> +       int err;
>> +       unsigned long i, siglen;
>> +       char *sig = NULL;
>> +
>> +       /* This is not a valid module: ELF header is larger anyway. */
>> +       if (*len < sizeof(MODULE_SIG_STRING))
>> +               return -ENOEXEC;
>> +
>> +       for (i = 0; i < *len - (sizeof(MODULE_SIG_STRING)-1); i++) {
>> +               /* Our memcmp is dumb, speed it up a little. */
>> +               if (((char *)mod)[i] != MODULE_SIG_STRING[0])
>> +                       continue;
>
> Since the signature is appended to the module, why don't you go
> backwards, starting from *len - strlen(sizeof(MODULE_SIG_STRING)) and
> making this first comparison?
>
> Or let the magic string as the last thing in the module and store the
> signature length, too. In this case no scanning is needed
>
>
> Lucas De Marchi
>

This is exactly like that here...

http://git.kernel.org/?p=linux/kernel/git/kasatkin/linux-digsig.git;a=blob;f=security/integrity/module.c;h=b111bb400a248ab9b03a64ea373c88396f311649;hb=19eef6e4e529ccf2b3a6ab5c19dd40f2eaf8fcaf

- Dmitry

>
>> +               if (memcmp(mod, MODULE_SIG_STRING, strlen(MODULE_SIG_STRING)))
>> +                       continue;
>> +
>> +               sig = mod + i + strlen(MODULE_SIG_STRING);
>> +               siglen = *len - i - strlen(MODULE_SIG_STRING);
>> +               *len = i;
>> +               break;
>> +       }
>> +
>> +       if (!sig)
>> +               err = 0;
>> +       else
>> +               err = mod_verify_sig(mod, len, sig, siglen, &info->sig_ok);
>> +
>> +       /* Not having a signature is only an error if we're strict. */
>> +       if (!err && !info->sig_ok && sig_enforce)
>> +               err = -EKEYREJECTED;
>> +       return err;
>> +}
>> +#else /* !CONFIG_MODULE_SIG */
>> +static int module_sig_check(struct load_info *info,
>> +                           void *mod, unsigned long *len)
>> +{
>> +       return 0;
>> +}
>> +#endif /* !CONFIG_MODULE_SIG */
>> +
>> +/* Sets info->hdr, info->len and info->sig_ok. */
>>  static int copy_and_check(struct load_info *info,
>>                           const void __user *umod, unsigned long len,
>>                           const char __user *uargs)
>> @@ -2419,6 +2500,10 @@ static int copy_and_check(struct load_info *info,
>>                 goto free_hdr;
>>         }
>>
>> +       err = module_sig_check(info, hdr, &len);
>> +       if (err)
>> +               goto free_hdr;
>> +
>>         /* Sanity checks against insmoding binaries or wrong arch,
>>            weird elf version */
>>         if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
>> @@ -2886,6 +2971,12 @@ static struct module *load_module(void __user *umod,
>>                 goto free_copy;
>>         }
>>
>> +#ifdef CONFIG_MODULE_SIG
>> +       mod->sig_ok = info.sig_ok;
>> +       if (!mod->sig_ok)
>> +               add_taint_module(mod, TAINT_FORCED_MODULE);
>> +#endif
>> +
>>         /* Now module is in final location, initialize linked lists, etc. */
>>         err = module_unload_init(mod);
>>         if (err)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
>
> Lucas De Marchi
