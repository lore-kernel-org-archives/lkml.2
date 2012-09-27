Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2I0VWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 17:22:03 -0400
Received: from mx2.netapp.com ([216.240.18.37]:13767 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab2I0VWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 17:22:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,496,1344236400"; 
   d="scan'208";a="695005250"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Topic: kernel BUG at /data/lemmy/linux.trees.git/fs/nfs/idmap.c:681!
Thread-Index: AQHNdKJvypEw9t3CEUmeaLKAlM+spZefC3UA//+TOzCAAHnyAIAACk6AgAAL+oCAAElqAA==
Date: Thu, 27 Sep 2012 21:21:59 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FF0BA2@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120807134156.GP1996@amd.com>
	 <20120927145217.GA18962@8bytes.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com>
	 <20120927153928.GB18962@8bytes.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com>
	 <CA+55aFx5CtDDpXTunJDtkDQWPX7sY0hYMRyekuPErC+s5yXpWw@mail.gmail.com>
In-Reply-To: <CA+55aFx5CtDDpXTunJDtkDQWPX7sY0hYMRyekuPErC+s5yXpWw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D87843DCFDF0644807960D0333C0D42@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8RLMDgB007296

On Thu, 2012-09-27 at 09:59 -0700, Linus Torvalds wrote:
> On Thu, Sep 27, 2012 at 9:16 AM, Myklebust, Trond
> <Trond.Myklebust@netapp.com> wrote:
> >
> > I cannot see how that BUG_ON can be triggered in the current code, given
> > that the only place where idmap->idmap_key_cons is set to a non-NULL
> > value is covered by a mutex, and that it is always cleared before we
> > release said mutex.
> 
> Quite frankly, the "I cannot see" thing is *never* an excuse for a BUG_ON().
> 
> We don't do kernel-killing asserts in Linux. Never.
> 
> The only excuse for a BUG_ON() is "I cannot possibly continue, I don't
> even have an error path I can take".
> 
> If it's a fundamentally impossible situation, the BUG_ON() should
> never have been there in the first place!
> 
> And if it's a "I don't see how it could happen", then it should have
> been something like
> 
>     if (WARN_ON_ONCE(condition))
>         goto cleanup;
> 
> rather than a BUG_ON().
> 
> We have too many f*cking BUG_ON's in the kernel, and the fact that one
> triggers and it has taken a month and a half without it even being
> resolved is a problem.
> 
> Get rid of the thing, already, dammit. If you cannot figure out how it
> can happen, then the *last* thing you want to do is then kill the
> machine so that it's impossible to debug it sanely.
> 
> Besides, as far as I can tell, idmap_key_cons locking is suspect
> anyway. Stuff like this:
> 
>                 cons = ACCESS_ONCE(idmap->idmap_key_cons);
>                 idmap->idmap_key_cons = NULL;
> 
> is an almost certain example of "the code is racy, and we did it
> wrong". The above is basically *never* correct.
> 
> If the access is properly locked, then the ACCESS_ONCE() is a bug.
> 
> And if the access *isn't* properly locked, then setting things to NULL
> afterwards is in no way safe.
> 
> IOW, either way, it's broken. And there's at least two of those
> clearly buggy code-sequences involving that field.
> 
> So get rid of the BUG_ON() (possibly replacing it with the
> WARN_ON_ONCE), and please look at those ACCESS_ONCE() sequences and
> fix them. Either they happen under a lock, or they don't. None of this
> crazy racy crap, please.

The ACCESS_ONCE is a bug. It isn't needed, since the whole upcall is
covered by the idmap_mutex. I'll remove it and the BUG_ON() come the
merge window (or I can send a patch sooner if you care).

The downcall is ordered w.r.t. idmap_pipe_destroy_msg() (which clears
idmap->idmap_key_cons only on upcall failure). The downcall is also
protected against collisions with idmap_release_pipe() by means of the
inode->i_mutex. Finally, the call to request_key() (during which the
idmap_mutex is held) will always do an uninterruptible wait for one of
those 3 functions to complete.
IOW: all the functions that manipulate idmap->idmap_key_cons are
theoretically ordered w.r.t. each other. That's what I mean when I say
that I really don't understand why this is happening.

So the first thing to do is to try a _vanilla_ 3.6-rc7, and see if the
problem is reproducible without Joerg's extra patches.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
