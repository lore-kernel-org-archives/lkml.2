Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1AMNhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:37:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1AMNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EIz1vRyu/H4aBCypped9sZmDWySuxkA+VKq/5Xkfc0He86lDWqG6yC3G9xEByIPoC4
         TjaZk5XaQ8vTTihQWdgtDlBfchFI7n7TlqObpWwv8JvedMQpytxTsm1tUxn+XUz+7c14
         BS5lHKUsSDNZruMhvuSqKDMJfziVqCtC66TBc=
Date: Thu, 13 Jan 2011 14:37:22 +0100
From: Tejun Heo <tj@kernel.org>
To: Karel Zak <kzak@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110113133722.GG30719@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
 <20110113110640.GC30719@htj.dyndns.org>
 <4D2EE156.1050006@redhat.com>
 <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110113132637.GH16523@nb.net.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Karel.

On Thu, Jan 13, 2011 at 02:26:37PM +0100, Karel Zak wrote:
> > Yeah, sure, it's not like I can afford to avoid fixing it at this
> > point anyway, but I still want to point out it's at the wrong layer
> > and shouldn't have been added like this, really.  If you want blkid to
> > identify it, the proper thing to do would be querying blk device for
> > the claimer and then use claimer-specific method to query them.  It's
> 
>  It seems that dependencies (holders/slaves) between devices is pretty
>  generic thing. Why do you think that we need claimer-specific method?
>  The /sys filesystem is better that ictls in many ways.

Because sysfs is already complex enough without representing
dependency information without strictly defined strcture in it.  It's
for exporting the device tree to users.  We have developed interesting
ways to exploit it but it generally has proven to be a bad idea to add
symlinks without clearly defined structure beneath it.  People end up
using them differently and often they don't understand how the kobject
sysfs things are wired and it ends up with a lot of cruft exporting
something which is designed by small number of people without really
considering what's going on in the rest of the hierarchy.

> > not like the current method would make sense for btrfs or whatnot.
> 
>  Could you be more verbose, please?

If the symlinkery was something which could properly replace
configuration and query, sure, let's standardize it and share it among
all possible claimers of block devices, but it's not.  md, dm, btrfs
need to export and process way more information than can be represnted
in these symlinks and it's there more as a pretty thing than anything
which is actually necessary and useful.  And the original
implementation directly played with kobjects (in an unnecessarily
complicated way too) and allowed any kobject to be linked.  Things
like that just never end up pretty.

So, just don't do it.  Sysfs is for device hierarchy.  Don't try to
shove pretty looking things there (unless it's something widely agreed
on and necessary, of course).

Thanks.

-- 
tejun
