Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2HPOOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:14:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32528 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab2HPOOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:14:07 -0400
Message-ID: <502D0021.5090004@parallels.com>
Date: Thu, 16 Aug 2012 18:13:53 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: James Bottomley <jbottomley@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120815092116.700948346@openvz.org>  <20120815092409.591460800@openvz.org> <20120815204546.GC25062@fieldses.org>  <20120815210237.GF25421@moon> <20120815220622.GA28054@fieldses.org>  <20120816062448.GA32081@moon> <20120816123814.GD1209@moon>  <20120816134339.GQ23464@ZenIV.linux.org.uk>  <502CF9DA.8030701@parallels.com>  <20120816135019.GS23464@ZenIV.linux.org.uk> <20120816135448.GP32081@moon> <1345125779.3259.50.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1345125779.3259.50.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 06:03 PM, James Bottomley wrote:
> On Thu, 2012-08-16 at 17:54 +0400, Cyrill Gorcunov wrote:
>> On Thu, Aug 16, 2012 at 02:50:19PM +0100, Al Viro wrote:
>>> On Thu, Aug 16, 2012 at 05:47:06PM +0400, Pavel Emelyanov wrote:
>>>> On 08/16/2012 05:43 PM, Al Viro wrote:
>>>>> On Thu, Aug 16, 2012 at 04:38:14PM +0400, Cyrill Gorcunov wrote:
>>>>>
>>>>>> Hi Bruce, thinking a bit more I guess using general encode_fh is not that
>>>>>> convenient since it operates with dentries while our fdinfo output deals
>>>>>> with inodes. Thus I should either provide some new encode_fh variant
>>>>>> which would deal with inodes directly without "parents". Which doesn't
>>>>>> look for me anyhow better than the new export_encode_inode_fh helper.
>>>>>
>>>>> Huh?  You do have dentries, for crying out loud...
>>>>
>>>> Sometimes we don't -- the inotify thing gets an inode only.
>>>> Unlike other notifies that have dentries at hands...
>>>
>>> What's wrong with saying "we don't support idiotify"?
>>
>> Al, we need some way to restore inotifies after checkpoint.
>> At the very early versions of these patches I simply added
>> dentry to the inotify mark thus once inotify created we always
>> have a dentry to refer on in encode_fh, but I'm not sure if
>> this will be good design.
> 
> Actually, I was about to suggest this.  This can be done internally
> within fs/notify without actually modifying the syscall interface, can't
> it, since they take a path which is used to obtain the inode?  It looks
> like the whole of the inotify interface could be internally recast to
> use dentries instead of inodes.  Unless I've missed something obvious?

This will change the observable by userspace behavior. Various apps inotify a
file, then rename/unlink/link it or do tricks with mounts container the file.
And it works one way if the dentry+mount reference is 0 (now) and some other
way if it's not (after the proposed change).

The dentries-related behavior is especially bad on NFS with its silly-renames
decisions based on dentry reference counters. The mount-related one is bad in
general.

I'm saying this, because we were facing such problems at approx. once-a-week
rate when we did this in OpenVZ :(

> James
> 

Thanks,
Pavel
