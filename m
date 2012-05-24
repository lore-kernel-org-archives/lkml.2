Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2EXPIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:08:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44631 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2EXPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:08:01 -0400
Date: Thu, 24 May 2012 17:07:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hui Zhu <teawater@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Geoff Levand <geoff@infradead.org>, jason.wessel@windriver.com
Subject: Re: [PATCH]KGTP (Linux Kernel debugger and tracer) lite patch for review
Message-ID: <20120524150754.GF27374@one.firstfloor.org>
References: <4FAA1953.60102@gmail.com> <20120509140538.GZ27374@one.firstfloor.org> <4FABB168.3060000@gmail.com> <20120510173808.GA27374@one.firstfloor.org> <4FBE3938.30000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBE3938.30000@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I remove them from asm files, and add:
> #ifndef ULONGEST
> #define ULONGEST		uint64_t
> #endif
> #ifndef CORE_ADDR
> #define CORE_ADDR		unsigned long
> #endif
> in gtp.c
> Then if not need, the arch didn't define ULONGEST and CORE_ADDR for itself.

Which architecture needs it? Linux prefers to use "native" types.

> For example ARM and MIPS have a lot of special reg that cannot be converted 
> by a for loop.
> 
> After check the code the kgdb, I thought that good ways is use dbg_reg_def 
> of kgdb to convert the reg to gdb rsp format.  But use it directly will 
> make kgtp depend on kgdb.

That's fine. Code reuse is good. Code duplication is bad.

> What I thought is move this part of code out from kgdb, when kgdb or kgtp 
> need, select it too.  But I am not sure Jason is OK with that.

Just send a patch.

> >
> >>+     memcpy(&freg->regs, regs, sizeof(struct pt_regs));
> >>+#ifdef CONFIG_X86_32
> >>+     freg->regs.sp = (unsigned long)&regs->sp;
> >>+#endif       /* CONFIG_X86_32 */
> >>+#ifdef CONFIG_X86
> >>+     freg->regs.ip -= 1;
> >>+#endif       /* CONFIG_X86 */
> >
> >What is that for? - 1?
> 
> That is because when kprobe, the ip of X86 point will have a offset with 
> current ip.

But a kprobe is not necessarily one byte. e.g. a jumper probe is longer.

Anyways if that is really needed there should be some macros provided
by kprobes to adjust IP. If it's not there it needs to be added.
> >>+
> >>+     if (gtp_start)
> >>+             return -EBUSY;
> >
> >This is in a lot of places. Can you put it somewhere more central?
> 
> Sorry I don't understand this part.  Do you want I change all "struct 
> gtp_entry        *tpe;" to "struct gtp_entry *tpe;"?

I mean the if (gtp_start) return -EBUSY check.

> >
> >>+     pr_devel("gtp_gdbrsp_QT: %s\n", pkg);
> >>+
> >>+     if (strcmp("init", pkg) == 0)
> >>+             ret = gtp_gdbrsp_qtinit();
> >
> >This if cascade should be probably a table walk
> 
> I cannot find the examle about it in the Kernel, could you give me a 
> example?


struct cmd {
	char *name;
	int (*init)(void);
};

struct cmd cmds[] = {
	{ "init", gtp_xyz_init }
	...
	{} 
};

int i;
for (i = 0; cmds[i].name; i++)
	if (!strcmp(cmds[i].name, pkg))
		ret = cmds->init();


> >Ok so what lock protects this buffer?
> 
> No.  The gtp_frame_lock protects the vars that follow it:
> static int			gtp_frame_num;
> static char			*gtp_frame;
> static char			*gtp_frame_r_start;
> static char			*gtp_frame_w_start;
> static char			*gtp_frame_w_end;
> static char			*gtp_frame_r_cache;
> static int			gtp_frame_is_circular;
> It protects them all.
> 
> gtp_m_buffer is protected by gtp_rw_lock that I just add in new patch.

Then your comment was wrong/unclear?

> 
> 
> OK.  Add some introduce.  checkpatch is OK with it.

You must be using an old version?

# check for Kconfig help text having a real description
# Only applies when adding the entry originally, after that we do not have
# sufficient context to determine whether it is indeed long enough.
...
        WARN("CONFIG_DESCRIPTION",
                             "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);

I wonder how you avoided that.

-Andi
