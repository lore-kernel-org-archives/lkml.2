Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1EUE06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 00:26:58 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:50634 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750894Ab1EUE0v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 00:26:51 -0400
X-ASG-Debug-ID: 1305952008-01c65a06b016fef0001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
X-Barracuda-BWL-IP: 192.168.1.136
X-Barracuda-BBL-IP: 192.168.1.136
X-Barracuda-RBL-IP: 192.168.1.136
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 5/7] overlay filesystem (inode.c bad error path)
Content-Type: text/plain; charset=windows-1252
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <7dcd9c4e62864bc6aae66f5a4e3f3752@HUBCAS1.cs.stonybrook.edu>
Date: Sat, 21 May 2011 00:26:47 -0400
Cc: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>, "neilb@suse.de" <neilb@suse.de>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2983EA36-BB3B-4AE3-9CAA-5A3C2D884DCF@fsl.cs.sunysb.edu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <103d3f78e2d3478d8bb93f5dda3a4a08@HUBCAS1.cs.stonybrook.edu> <D8301738-5094-4666-8C4D-E26425F1AD66@fsl.cs.sunysb.edu> <87wrhlah1e.fsf@tucsk.pomaz.szeredi.hu> <7dcd9c4e62864bc6aae66f5a4e3f3752@HUBCAS1.cs.stonybrook.edu>
To: Miklos Szeredi <miklos@szeredi.hu>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1305952008
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.52
X-Barracuda-Spam-Status: No, SCORE=-1.52 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE_7582B
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64348
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE_7582B         Custom Rule 7582B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 20, 2011, at 10:17 AM, Miklos Szeredi wrote:

> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
>> Erez Zadok <ezk@fsl.cs.sunysb.edu> writes:
>> 
>>> I tried your overlayfs.v9 git repo w/ racer, using two separate ext3
>>> filesystems (one for lowerdir and another for upperdir).  I got the
>>> WARN_ON in ovl_permission to trigger within about 10 minutes of
>>> testing.  Looking at the code, I see a problem in returning w/o
>>> cleaning up an dput-ing the alias dentry.  Simple patch enclosed
>>> below.
>> 
>> Hmm, thanks.  The more interesting question is: why does that WARN_ON
>> trigger?  I'll look into it.
> 
> I think I found the cause of all the bug and oopsen you are seeing.
> 
> Overlayfs expects upper and lower dentries to be always positive, it
> never stores negative dentries there, there's no point, instead it
> stores NULL.
> 
> There are basically two ways a positive dentry can become negative:
> 
> A) dentry becomes unhashed with d_count == 0
> 
> B) d_delete with d_count == 1
> 
> Case A is not possible in our case, since overlayfs keeps a ref on the
> upper/lower dentries for the lifetime of the overlayfs dentry.
> 
> Case B is however possible, since no extra ref is taken before calling
> vfs_unlink/vfs_rmdir.  So it looks like this is being triggered.
> 
> This is easy to solve, just grab a ref to upperdentry before
> unlink/rmdir.  Equivalent is if we grab an extra reference from the
> start.  The below patch does this.
> 
> With the patch I can't trigger the bugs anymore.
> 
> Erez, could you please also check if reverting your patches and applying
> this one fixes all the bugs?

Done: reverted my ovl patches and applied yours.  And indeed, the NULL oopses don't show up after 10 minutes of running.  Just to be sure, I ran overlayfs on top of ext2, ext3, xfs, reiserfs, and tmps — no oopses.  And I wasn't able to reproduce the WARN_ON in ovl_permission.

Are you interested in testing overlayfs on top of NFS at this time? You need xattr support right? Stacking over NFS takes extra effort, esp. b/c of the pesky silly deleted files and needing a nameidata everywhere (but I managed after a while to get Wrapfs working stably over nfs3).

> Thanks,
> Miklos
> 
> commit 9192816148e2c6b1d610226b1fc1c04c36216370
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Fri May 20 16:07:34 2011 +0200
> 
>    ovl: don't allow upperdentry to go negative
[...]

Do you commit such patches to a master branch, the v9 branch, or some other one; I'd like to be able to git pull

Thanks,
Erez.

