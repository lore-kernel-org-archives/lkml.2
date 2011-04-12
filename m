Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab1DLUUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:20:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab1DLUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:20:20 -0400
Message-ID: <4DA4B3FE.2080609@redhat.com>
Date: Tue, 12 Apr 2011 15:20:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Karel Zak <kzak@redhat.com>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412190934.GA12082@redhat.com>
In-Reply-To: <20110412190934.GA12082@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/11 2:09 PM, Dave Jones wrote:
> On Mon, Apr 11, 2011 at 05:40:11PM -0700, Linus Torvalds wrote:
>  > It's been another almost spookily calm week. Usually this kind of
>  > calmness happens much later in the -rc series (during -rc7 or -rc8,
>  > say), but I'm not going to complain. I'm just still waiting for the
>  > other shoe to drop.
>  
> Here's an odd one.
> 
> my laptop's fstab has
> 
> /dev/mapper/vg_adamo-lv_home /home                   ext4    defaults        1 2
> 
> on 2.6.38, /proc/mounts contains ..
> 
> /dev/mapper/vg_adamo-lv_home /home ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
> 
> on 2.6.39rc3 it looks like..
> 
> /dev/mapper/vg_adamo-lv_home /home ext4 rw,seclabel,relatime,user_xattr,barrier=1,data=ordered 0 0
> 
> 
> Which looks like ea6633369458992241599c9d9ebadffaeddec164, so nothing untoward..
> 
> however, the output of mount looks very confused..
> 
> .38:
> /dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
> 
> .39:
> - on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)
> 
> It looks like /proc/self/mountinfo broke abi.
> 
> .38:
> 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
> 
> .39:
> 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered
> 

so it's supposed to be like this, from Documentation/filesystems/proc.txt:

> This file contains lines of the form:
> 
> 36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 /dev/root rw,errors=continue
> (1)(2)(3)   (4)   (5)      (6)      (7)   (8) (9)   (10)         (11)
> 
> (1) mount ID:  unique identifier of the mount (may be reused after umount)
> (2) parent ID:  ID of parent (or of self for the top of the mount tree)
> (3) major:minor:  value of st_dev for files on filesystem
> (4) root:  root of the mount within the filesystem
> (5) mount point:  mount point relative to the process's root
> (6) mount options:  per mount options
> (7) optional fields:  zero or more fields of the form "tag[:value]"
> (8) separator:  marks the end of the optional fields
> (9) filesystem type:  name of filesystem of the form "type[.subtype]"
> (10) mount source:  filesystem specific information or "none"
> (11) super options:  per super block options

it does seem that the new UUID info is in a perfectly fine place (the optional fields slot), at least per the docs, so I guess I might blame the mount binary for not following the aforementioned rules...

Maybe Karel knows?  cc'd...

-Eric

> 
> 	Dave
> 

