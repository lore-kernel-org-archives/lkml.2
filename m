Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0ICI4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:56:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64066 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0ICI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=X/3gJhZW+wvGM5t8OYQzYF+vJYCzeegruNQM84KvZUIqn4lvxgNwDSpEd1Yu7HAxCX
         WVvbRVmETIctJKAekvr/u+7nFknDpHSNMJMJkhKBgcm2cclzM6PRoVF9q1ev2gXl6Pf1
         j7S6fKC9Quhu8FxQZh1DY/RUQ2RUUd2LlROO0=
Message-ID: <4C80B81F.8090803@gmail.com>
Date: Fri, 03 Sep 2010 10:55:59 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [linux-pm] [PATCH] libata: skip EH autopsy and recovery during
 suspend
References: <Pine.LNX.4.44L0.1009021646510.1311-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1009021646510.1311-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Jens and Christoph and quoting whole body for them.

On 09/02/2010 11:01 PM, Alan Stern wrote:
> On Thu, 2 Sep 2010, Tejun Heo wrote:
> 
>> Hello,
>>
>> On 09/02/2010 10:28 PM, Rafael J. Wysocki wrote:
>>> That would be very nice.  In particular, I'd like to get rid of the
>>> pm_message_t thing if possible.  And I'd like to avoid putting the
>>> controller into D3 before creating hibernation image. :-)
> 
> Ultimately I don't think it will be possible to get rid of pm_message_t
> throughout the entire kernel.  Not just because it's a legacy thing
> spread all over the place, but because it sometimes is genuinely
> useful.  In situations where there are only minimal differences between
> the various suspend/resume paths, it makes a lot of sense to call a
> single function and tell it which type of operation to perform.
> 
>> Oh, yeah, things like that can definitely be changed, but I think it
>> would still need to be piped through EH.  That's how the queue gets
>> quiesced for those special operations and resume is basically probing,
>> so it doesn't make much sense to split them.  Please let me know how
>> it should work from power management POV and I'll be happy to convert
>> libata to fit the new behavior.
> 
> Tejun, I'm planning to make a few changes to the block layer and the
> SCSI core in order to implement delayed autosuspend.  These changes
> will affect system sleep too, so you may need to know about them.
> 
> Each request_queue structure will have an rpm_status variable that gets
> updated as the corresponding device is suspended or resumed.  When the
> status is SUSPENDING or RESUMING, requests will not be sent from the
> request_queue to the driver unless they have cmd_type set to
> REQ_TYPE_PM_SUSPEND or REQ_TYPE_PM_RESUME (actually I may combine those
> two into a single REQ_TYPE_PM type).  If other types of request are
> added to the queue when the status isn't ACTIVE, they will cause a
> runtime resume to be started.
> 
> Initially this will affect only drivers using the SCSI layer.  
> Commands sent during error handling won't be affected though, because
> the SCSI error handler doesn't use requests or queues -- it sends
> commands directly to the lower-level driver.
> 
> Does that all sound okay to you?

Hmm... I can't really tell much without looking at the actual patch
but I'm a bit doubtful about using REQ_TYPE_* for suspend/resumes,
well, for that matter, for any other purpose than actual IO requests.
The current REQ_TYPE_PM_* are only used by ide and it's really messy.

Those special requests are very difficult to use in generic manner.
ie. How should remapping / cloning drivers like md, dm and loopback
handle them?  They end up just being a mechanism for specific low
level drivers to feed certain requests back to themselves to implement
suspend/resume sequence and as there's no clear defined common usage,
the meaning of those flags becomes ambiguous and confusing depending
on drivers and so on.

Another issue is that power management is probably better handled as a
sub problem of generic IO exception handling.  If you throw in
hot[un]plugs and transport errors and consider what should happen when
those events happen together, things get hairy if power management is
not well integrated with the usual exceptionn handling.

Thanks.

-- 
tejun
