Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab2AEQBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:01:09 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50316 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab2AEQBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:01:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Theodore Ts'o" <tytso@mit.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with unregistration]
References: <m1boqietiv.fsf@fess.ebiederm.org>
	<Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
	<20120105153233.GA11934@google.com>
Date: Thu, 05 Jan 2012 08:03:16 -0800
In-Reply-To: <20120105153233.GA11934@google.com> (Tejun Heo's message of "Thu,
	5 Jan 2012 07:32:33 -0800")
Message-ID: <m1ehvecf23.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/aQnrBZoYRaChwHzQcozMTQ4zt/MEbhpk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Thu, Jan 05, 2012 at 10:13:31AM -0500, Alan Stern wrote:
>> I don't have a clear idea of what's involved (in particular, how to go
>> from a block_device structure to a mounted filesystem).  But the place
>> to do it would probably be block/genhd.c:invalidate_partition().  Ted
>> can tell you if there's a better alternative.
>> 
>> > Do you know how hard it is to detect at mount time if a block device
>> > might be hot-plugable?  We can always use a mount option here and
>> > make userspace figure it out, but being to have a good default would
>> > be nice.
>> 
>> I don't think it's possible to tell if a device is hot-unpluggable.  
>> For example, the device itself might not be removable from its parent, 
>> but the parent might be hot-unpluggable.  You'll probably have to 
>> assume that every device can potentially be unplugged, one way or 
>> another.
>> 
>> Also, even devices that aren't hot-unpluggable can fail.  The end 
>> result should be pretty much the same.
>
> Ummm.... I could be missing something but filesystems need to be able
> to deal with partial device failures (ie. some block can't be read)
> and hot-unplug or handling full failure is a logical extension of
> that.  That's how it already works, so I don't really think that is a
> particularly good application for the revoke mechanism.

Well the choices are really:
a) On a block device hotunplug keep the device and have it simply report
   everything as errors, to the filesystem.  Maybe with a hint to the
   filesystem that something is wrong.
b) Have a filesystem revoke method so that we don't have to keep the
   unplugged block device structure around indefinitely.

It seems clear that we are neither doing (a) or (b) which results in
periodic and spectacular failures when block devices are unplugged,
because we try and access block devices that no longer exist.

Eric
