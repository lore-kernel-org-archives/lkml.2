Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0KZHtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:49:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab0KZHtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:49:01 -0500
Date: Fri, 26 Nov 2010 08:48:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101126074809.GD19589@elte.hu>
References: <20101116104600.GA24015@suse.de>
 <20101119191906.GA31760@xanatos>
 <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Nov 19, 2010 at 11:19 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> >
> > .config and dmesg are attached.  The box is running klogd 1.5.5ubuntu3
> > (from Jaunty).  Yes, I know that's old.  I read the bit in the commit
> > about changing the permissions of kallsyms after boot, but if I can't
> > boot that doesn't help.  Perhaps this can be made a configuration
> > option?
> 
> It's not worth a config option.
> 
> If it actually breaks user-space, I think we should just revert it.

Sarah,

Does your system boot fine if we make /proc/kallsyms simply an empty file to 
unprivileged users? Something like the (untested ...) patch below.

	Ingo

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6f6d091..d54c993 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -465,7 +465,7 @@ static int s_show(struct seq_file *m, void *p)
 	struct kallsym_iter *iter = m->private;
 
 	/* Some debugging symbols have no name.  Ignore them. */
-	if (!iter->name[0])
+	if (!iter->name[0] || !capable(CAP_SYS_ADMIN))
 		return 0;
 
 	if (iter->module_name[0]) {
