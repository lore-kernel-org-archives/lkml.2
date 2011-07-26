Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1GZUTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:19:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65281 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab1GZUTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110725200204.GA13627@elte.hu>
References: <20110722125236.GA24832@elte.hu>
	<CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
	<1311588599.2617.56.camel@laptop>
	<CA+55aFwxqVXb0cFrkgdrDH4J_aF9J7iw8i6ypAda2HiAyeFYpw@mail.gmail.com>
	<20110725190444.GA8302@elte.hu>
	<CA+55aFyDufcXR62j=crthVkNybk5is+c-zzr+LRmj_QSUskfmg@mail.gmail.com>
	<20110725200204.GA13627@elte.hu>
Date: Tue, 26 Jul 2011 16:19:20 -0400
Message-ID: <CACqU3MV70A-nk4FPATVfPy1kJV5p6qHW+7jYg+8w8gbAwBOEvw@mail.gmail.com>
Subject: Re: [GIT PULL] core/locking changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 4:02 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Mon, Jul 25, 2011 at 12:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> > ..
>> > net/netfilter/nf_conntrack_core.c: In function ‘nf_conntrack_init’:
>> > net/netfilter/nf_conntrack_core.c:1579:3: warning: the comparison
>> > will always evaluate as ‘true’ for the address of
>> > ‘nf_conntrack_attach’ will never be NULL [-Waddress]
>>
>> These all seem to be essentially compiler bugs.
>>
>> We have macros that do generic things (in this case
>> "rcu_assign_pointer()" and tests their values. The fact that the tests
>> sometimes end up being statically true (or false) is not something the
>> compiler should complain about - it should use it to optimize the
>> code.
>>
>> Sad.
>>
>> We can make a compiler bug-report, or disable -Waddress. Or maybe we
>> can write the tests in a way that doesn't trigger the compiler bug.
>>
>> This same issue is why I hated -Wsign-compare. Some of the things
>> gcc complained about were just technically moronic. So compiler
>> warnings are not always a good thing.
>
> With -Wno-address added (see the first patch below) it looks a lot
> more useful:
>
> aldebaran:~/linux/linux> make -j32 >e
> sound/pci/hda/patch_sigmatel.c: In function ‘stac92xx_init’:
> sound/pci/hda/patch_sigmatel.c:4385:3: warning: statement with no
> effect [-Wunused-value]
> sound/pci/hda/patch_sigmatel.c: In function ‘stac92xx_resume’:
> sound/pci/hda/patch_sigmatel.c:4925:3: warning: statement with no
> effect [-Wunused-value]
> sound/pci/hda/patch_realtek.c: In function ‘alc_init’:
> sound/pci/hda/patch_realtek.c:4176:2: warning: statement with no
> effect [-Wunused-value]
> sound/pci/hda/patch_realtek.c: In function ‘alc_resume’:
> sound/pci/hda/patch_realtek.c:4558:2: warning: statement with no
> effect [-Wunused-value]
> sound/pci/hda/hda_codec.c: In function
> ‘snd_hda_mixer_amp_switch_put’:
> sound/pci/hda/hda_codec.c:2320:2: warning: statement with no effect
> [-Wunused-value]
> sound/pci/hda/patch_realtek.c: In function ‘alc269_resume’:
> sound/pci/hda/patch_realtek.c:14878:2: warning: statement with no
> effect [-Wunused-value]
> drivers/md/dm.c: In function ‘split_bvec’:
> drivers/md/dm.c:1052:3: warning: statement with no effect
> [-Wunused-value]
> drivers/md/dm.c: In function ‘clone_bio’:
> drivers/md/dm.c:1079:3: warning: statement with no effect
> [-Wunused-value]
> drivers/md/dm-table.c: In function ‘dm_table_set_integrity’:
> drivers/md/dm-table.c:1193:2: warning: statement with no effect
> [-Wunused-value]
> Setup is 15260 bytes (padded to 15360 bytes).
> System is 4654 kB
> CRC 6d1b94ea
>
> those unused-x warnings seem legit and should be fixed. For example
> the second patch below fixed the dm.c warnings.
>
> That's with:
>
>  gcc version 4.6.0 20110509 (Red Hat 4.6.0-7) (GCC)
>
> so a reasonably recent GCC. I think we should kill -Waddress.
>
> Thanks,
>
>        Ingo
>
> diff --git a/Makefile b/Makefile
> index d018956..e651294 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -559,9 +559,9 @@ endif # $(dot-config)
>  all: vmlinux
>
>  ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
> -KBUILD_CFLAGS  += -Os
> +KBUILD_CFLAGS  += -Os -Wno-address
>  else
> -KBUILD_CFLAGS  += -O2
> +KBUILD_CFLAGS  += -O2 -Wno-address
>  endif
>
did you submit this to linux-kbuild@ ?

>  include $(srctree)/arch/$(SRCARCH)/Makefile
>
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ce33e68..283250a 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -527,7 +527,7 @@ extern void bio_integrity_init(void);
>  #define bioset_integrity_create(a, b)  (0)
>  #define bio_integrity_prep(a)          (0)
>  #define bio_integrity_enabled(a)       (0)
> -#define bio_integrity_clone(a, b, c, d)        (0)
> +#define bio_integrity_clone(a, b, c, d)        ({0;})
>  #define bioset_integrity_free(a)       do { } while (0)
>  #define bio_integrity_free(a, b)       do { } while (0)
>  #define bio_integrity_endio(a, b)      do { } while (0)
>
likewise, but to the maintainer of `include/linux/bio.h' ?
