Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2BCJ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:28:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55185 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2BCJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:28:28 -0500
Date: Fri, 3 Feb 2012 13:28:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120203092823.GE1968@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:22:41AM -0800, Andrew Morton wrote:
> On Fri, 3 Feb 2012 10:09:29 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > > > +			get_random_bytes(&cookies[i][j],
> > > > > +					 sizeof(cookies[i][j]));
> > > > 
> > > > ugly line break.
> > > > 
> > > 
> > > Why? Looks pretty good to me. But sure I'll change it.
> > 
> > It's ugly because it serves no purpose other than pacifying 
> > checkpatch and makes the code *uglier*.
> 
> No it doesn't.  For 80-col displays the code is *already wrapped*.  And
> that wrapping to column 0 is vastly worse than the above.
> 
> If we want to increase the standard to (say) 96 cols then fine, I'd be
> happy with that.  But until we do that we should not create such a
> gruesome mess for those who use 80 cols.
> 
> > It's a disease. When checkpatch tells you "this line is too 
> > long" then consider it a code cleanliness warning!
> 
> Well yes, if it can be fixed by other means then great.
> 

Guys, I simply made it as

static __init int kcmp_cookie_init(void)
{
	int i, j;

	for (i = 0; i < KCMP_TYPES; i++) {
		for (j = 0; j < 2; j++)
			get_random_bytes(&cookies[i][j], sizeof(long));
		cookies[i][1] |= (~(~0UL >>  1) | 1);
	}

	return 0;
}

I thought in first place that sizeof(cookies[i][j]) would allow me
to change type of cookies in one place (ie at declaration) but
if cookies type will be changed -- the code will need careful review
anway, so sizeof(long) will be enough I think.

On the other hands, maybe more clean variant will be

static __init int kcmp_cookie_init(void)
{
	const int size = sizeof(cookies[0][0]);
	int i, j;

	for (i = 0; i < KCMP_TYPES; i++) {
		for (j = 0; j < 2; j++)
			get_random_bytes(&cookies[i][j], size);
		cookies[i][1] |= (~(~0UL >>  1) | 1);
	}

	return 0;
}

Hm?

	Cyrill
