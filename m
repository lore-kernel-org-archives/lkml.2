Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab2CMTGJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:06:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50520 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab2CMTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:06:06 -0400
Message-ID: <4F5F9A97.5060404@ubuntu.com>
Date: Tue, 13 Mar 2012 15:05:59 -0400
From: Phillip Susi <phillsusi@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@whamcloud.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Jacek Luczak <difrost.kernel@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: getdents - ext4 vs btrfs performance
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <alpine.LFD.2.00.1203091158430.4487@dhcp-27-109.brq.redhat.com> <BCAD47C1-B95A-4EDB-8EFB-3D4E325DE57D@whamcloud.com> <20120310044804.GB5652@thunk.org>
In-Reply-To: <20120310044804.GB5652@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/2012 11:48 PM, Ted Ts'o wrote:
> I suspect the best optimization for now is probably something like
> this:
>
> 1) Since the vast majority of directories are less than (say) 256k
> (this would be a tunable value), for directories which are less than
> this threshold size, the entire directory is sucked in after the first
> readdir() after an opendir() or rewinddir().  The directory contents
> are then sorted by inode number (or loaded into an rbtree ordered by
> inode number), and returned back to userspace in the inode order via
> readdir().  The directory contents will be released on a closedir() or
> rewinddir().

Why not just separate the hash table from the conventional, mostly in 
inode order directory entries?  For instance, the first 200k of the 
directory could be the normal entries that would tend to be in inode 
order ( and e2fsck -D would reorder ), and the last 56k of the directory 
would contain the hash table.  Then readdir() just walks the directory 
like normal, and namei() can check the hash table.

