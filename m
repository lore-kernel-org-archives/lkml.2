Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0CZXWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:22:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab0CZXWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:22:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=o714SYr+hCSC4O1SCb5WsUwXRJsPSG05ofA0Nm9pMI7a/+Iu4ud8WF8EQbso9jhd0
	wsaL4YAWeW1C36M2X3eGg==
MIME-Version: 1.0
In-Reply-To: <1786ab031003261554y40c21bc8sb4ea2f347c2c8bf8@mail.gmail.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com> 
	<4BAC0E7D.9080305@cn.fujitsu.com> <20100326152012.GB18128@redhat.com> 
	<1786ab031003261554y40c21bc8sb4ea2f347c2c8bf8@mail.gmail.com>
From: Divyesh Shah <dpshah@google.com>
Date: Fri, 26 Mar 2010 16:21:41 -0700
Message-ID: <af41c7c41003261621qe95f634rc795045e29048295@mail.gmail.com>
Subject: Re: [PATCH 0/4] io-controller: Use names rather than major:minor
To: Chad Talbott <ctalbott@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       jens.axboe@oracle.com, mrubin@google.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Nauman Rafique <nauman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 3:54 PM, Chad Talbott <ctalbott@google.com> wrote:
> On Fri, Mar 26, 2010 at 8:20 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Fri, Mar 26, 2010 at 09:31:41AM +0800, Gui Jianfeng wrote:
>>> +int blk_lookup_devname(dev_t devt, char *name)
>>> +{
>
> [ snip... loop through all block devices for devt ...snip ]
>
>>> So we can keep dev_t in blkio layer, and export to user a device name by calling
>>> this function. Also, we retrive device number by calling blk_lookup_devt().
>>> This change might keep things much simple. Jens, do you have any thoughts?
>>>
>> I agree with Gui that lets keep the dev_t the core in blkio layer. Keeping
>> a pointer to gendisk in request queue is becoming little messy.
>
> Agreed on leaving gendisk pointer out of request_queue.  In doing
> further investigation, I've found that it's up to the driver to
> maintain the association between gendisk and request_queue, and some
> drivers put multiple gendisk behind a single request_queue, so the
> back pointer would be ill-specified.
>
>> But if that does not work for you, then I would also like to keep things
>> simple and translate dev_t to diskname during read routine. Similiarly,
>> while somebody is putting policy, use blk_lookup_devt().
>
> I like the simplicity of blk_lookup_devt(), but I don't like the idea
> of iterating through all block devices on every lookup of the name.
> Perhaps we could cache the name somewhere?
>
> Actually, the name is the name of the *queue* (or the key in
> blk-cgroup), because as I mentioned above there can be a many to one
> relationship between disks and queues in general.
>
> The more I think about it, the more it seems to make sense to extend
> blkio_policy_ops to include a function to get the name of the key.
> blk-cgroup makes no current use of the dev, except to invent a name
> for the request_queue whose policy is being set or printed.  It could
> be argued that the thing being scheduled has a better idea of the name
> of that thing.
>
>> But this will lead to issue of how do you now display both device number
>> and disk name in the output. May be following.
>>
>> major:minor  diskname  data
>>
>> I am not sure if people are fond of multiple values in a single file. At
>> the same time for setting the rules or deleting the rules, it will make
>> syntax complicated/confusing. Also will require breaking ABI for existing
>> blkio.time, blkio.sectors, blkio.dequeue files.
>
> I don't like this, either.  It breaks ABI and is more confusing for users.
>
>> So I would prefer to keep the major/minor number based interface for
>> follwing reasons.
>>
>> - Chaning it now breaks ABI.
>> - Other cgroup controller "device" is also using major/minor number based
>>  interface for device access policy. So it is consistent with other
>>  controller.
>
> Which controllers are these?
>
>> - Displaying both device major/minor and diskname is an option but that
>>  makes the file format syntax little complicated and new rule setting
>>  or removoal confusing.
>
> A few messages back you mentioned that you preferred device names
> because they would be better for users of the system.  If there was a
> simple implementation, would you still be behind a new name-based
> interface?  We could go that direction and maintain ABI by deprecating
> current interface and making a new interface with names.
>
> If you can't tell, I'm a big fan of using the name! :)  It's *much*
> more consistent with the interfaces in /sys.

I agree with Chad here. The major/minor number interface to me seems
like a departure from convention as /proc/diskstat, /sys/block all use
the device names at the kernel-user interface. About deprecating the
current ABI, we could do that but do we expect a lot of user tools to
be built around this interface since the 2.6.33 release already?

-Divyesh

>
> Chad
>
