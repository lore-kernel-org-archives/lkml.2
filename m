Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab2EYQ2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:28:15 -0400
Received: from mail130c7-2520.megamailservers.com ([69.49.98.25]:55932 "EHLO
	mail130c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752893Ab2EYQ2N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:28:13 -0400
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com> <20120525154249.GC2082@localhost.localdomain> <CAB9VWqDGgWE8S4dS5izkzUGEWkUbFSanWCV5trm7VWB0=r-tXQ@mail.gmail.com>
In-Reply-To: <CAB9VWqDGgWE8S4dS5izkzUGEWkUbFSanWCV5trm7VWB0=r-tXQ@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <C15A7948-95DF-4B4E-A560-A10A181DE9BB@dilger.ca>
Content-Transfer-Encoding: 8BIT
Cc: Josef Bacik <josef@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (9B206)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
Date: Fri, 25 May 2012 10:28:16 -0600
To: Alexander Block <ablock84@googlemail.com>
X-CSC: 0
X-CHA: v=1.1 cv=jegz8rrpTsCmfIP3oxsmQwLmgXLlG4mytwnW3LPhSlA= c=1 sm=1
		a=YuIRh4qCXNUA:10 a=kj9zAlcOel0A:10 a=akHhUqyx16pf1Jmt3m6W8Q==:17
		a=mK_AVkanAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ugi5tw-vNKP-JgWLt-YA:9
		a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=9xyTavCNlvEA:10 a=jEp0ucaQiEUA:10
		a=akHhUqyx16pf1Jmt3m6W8Q==:117
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020204.4FBFB317.0011,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-25, at 9:59, Alexander Block <ablock84@googlemail.com> wrote:

> On Fri, May 25, 2012 at 5:42 PM, Josef Bacik <josef@redhat.com> wrote:
>> On Fri, May 25, 2012 at 05:35:37PM +0200, Alexander Block wrote:
>>> Hello,
>>> 
>>> (this is a resend with proper CC for linux-fsdevel and linux-kernel)
>>> 
>>> I would like to start a discussion on atime in Btrfs (and other
>>> filesystems with snapshot support).
>>> 
>>> As atime is updated on every access of a file or directory, we get
>>> many changes to the trees in btrfs that as always trigger cow
>>> operations. This is no problem as long as the changed tree blocks are
>>> not shared by other subvolumes. Performance is also not a problem, no
>>> matter if shared or not (thanks to relatime which is the default).
>>> The problems start when someone starts to use snapshots. If you for
>>> example snapshot your root and continue working on your root, after
>>> some time big parts of the tree will be cowed and unshared. In the
>>> worst case, the whole tree gets unshared and thus takes up the double
>>> space. Normally, a user would expect to only use extra space for a
>>> tree if he changes something.
>>> A worst case scenario would be if someone took regular snapshots for
>>> backup purposes and later greps the contents of all snapshots to find
>>> a specific file. This would touch all inodes in all trees and thus
>>> make big parts of the trees unshared.

Are you talking about the atime for the primary copy, or the atime for the snapshots?  IMHO, the atime should not be updated for a snapshot unless it is explicitly mounted r/w, or it isn't really a good snapshot. 

>>> relatime (which is the default) reduces this problem a little bit, as
>>> it by default only updates atime once a day. This means, if anyone
>>> wants to test this problem, mount with relatime disabled or change the
>>> system date before you try to update atime (that's the way i tested
>>> it).
>>> 
>>> As a solution, I would suggest to make noatime the default for btrfs.
>>> I'm however not sure if it is allowed in linux to have different
>>> default mount options for different filesystem types. I know this
>>> discussion pops up every few years (last time it resulted in making
>>> relatime the default). But this is a special case for btrfs. atime is
>>> already bad on other filesystems, but it's much much worse in btrfs.
>>> 
>> 
>> Just mount with -o noatime, there's no chance of turning something like that on
>> by default since it will break some applications (notably mutt).  Thanks,
>> 
>> Josef
> 
> I know about the discussions regarding compatibility with existing
> applications. The problem here is, that it is not only a compatibility
> problem. Having atime enabled by default, may give you ENOSPC
> for reasons that a normal user does not understand or expect.
> As a normal user, I would think: If I never change something, why
> does it then take up more space just by reading it?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
