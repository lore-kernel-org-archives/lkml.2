Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab2EPGPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:15:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40532 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2EPGPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:15:48 -0400
Date: Tue, 15 May 2012 23:14:17 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 10/11] pstore/ram: Switch to persistent_ram routines
Message-ID: <20120516061416.GB18058@lizard>
References: <20120512001506.GA8653@lizard>
 <20120512001840.GJ14782@lizard>
 <CAGXu5j+BPHPCnJ+ont8CGuUjjEYB_d6K-YtVJgNA7uwkpbfDoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+BPHPCnJ+ont8CGuUjjEYB_d6K-YtVJgNA7uwkpbfDoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

On Mon, May 14, 2012 at 03:21:17PM -0700, Kees Cook wrote:
[...]
> > -       buf = cxt->virt_addr + (id * cxt->record_size);
> > -       memset(buf, '\0', cxt->record_size);
> > +       persistent_ram_free_old(cxt->przs[id]);
> 
> Hm, I don't think persistent_ram_free_old() is what's wanted here.
> That appears to entirely release the region? I want to make sure the
> memory is cleared first. And will this area come back on a write, or
> does it stay released?

It just releases ECC-restored memory region (a copy). The original
(persistent) region is still fully reusable after that call.

(It is a pity that pstore internals can't use the restored copy
directly, as pstore expects that it will release the region itself
after pstore_mkfile(), so we somewhat duplicate the memory during
psi->read(). We'd better fix it some day, but it's a minor issue
so far.)

> >
> >        return 0;
> >  }
> > @@ -200,6 +203,7 @@ static int __init ramoops_probe(struct platform_device *pdev)
> >        struct ramoops_platform_data *pdata = pdev->dev.platform_data;
> >        struct ramoops_context *cxt = &oops_cxt;
> >        int err = -EINVAL;
> > +       int i;
> >
> >        /* Only a single ramoops area allowed at a time, so fail extra
> >         * probes.
> > @@ -237,32 +241,37 @@ static int __init ramoops_probe(struct platform_device *pdev)
> >        cxt->record_size = pdata->record_size;
> >        cxt->dump_oops = pdata->dump_oops;
> >
> > +       cxt->przs = kzalloc(sizeof(*cxt->przs) * cxt->max_count, GFP_KERNEL);
> > +       if (!cxt->przs) {
> > +               pr_err("failed to initialize a prz array\n");
> > +               goto fail_przs;
> 
> This should be fail_out.

Thanks, will fix all of these error handling negligences.

> > +       }
> > +
> > +       for (i = 0; i < cxt->max_count; i++) {
> > +               size_t sz = cxt->record_size;
> > +               phys_addr_t start = cxt->phys_addr + sz * i;
> > +
> > +               cxt->przs[i] = persistent_ram_new(start, sz, 0);
> 
> persistent_ram_new() is marked as __init, so this is unsafe to call if
> built as a module. I think persistent_ram_new() will need to lose the
> __init marking, or I'm misunderstanding something.

Um. ramoops' probe routine is also __init. persistent_ram_new is a
part of ramoops module, so their __init functions will be discarded
at the same time.

ram_console can't be a module, so it is also fine.

So I think it's all fine.

> > +               if (IS_ERR(cxt->przs[i])) {
> > +                       err = PTR_ERR(cxt->przs[i]);
> > +                       pr_err("failed to initialize a prz\n");
> 
> Since neither persistent_ram_new() nor persistent_ram_buffer_map()
> report the location of the failure, I'd like to keep the error report
> (removed below "pr_err("request mem region (0x%lx@0x%llx)
> failed\n",...") for failures, so there is something actionable in
> dmesg when the platform data is mismatched for the hardware.

Sure thing, will do. I'll also start using dev_err() for new
code, that way it's more clearer which module reported the error.

[...]
> >        cxt->pstore.data = cxt;
> > -       cxt->pstore.bufsize = cxt->record_size;
> > -       cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
> >        spin_lock_init(&cxt->pstore.buf_lock);
> > +       cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
> > +       cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
> 
> I don't see a reason to re-order these (nothing can use buf yet
> because we haven't registered it with pstore yet).

Yeah, this is a left over. Thank for catching.

[...]
> > +fail_przs:
> > +       for (i = 0; cxt->przs[i]; i++)
> > +               persistent_ram_free(cxt->przs[i]);
> 
> This can lead to a BUG, since persistent_ram_free() doesn't handle
> NULL arguments.

The for loop has 'cxt->przs[i]' condition. :-)

Thanks for the review!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
