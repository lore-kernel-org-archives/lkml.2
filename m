Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab0JRLz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:55:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0JRLz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:55:26 -0400
Message-ID: <4CBC35AE.9050002@suse.de>
Date: Mon, 18 Oct 2010 13:55:26 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu,
        tytso@mit.edu, linux-scsi@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, jaxboe@fusionio.com, jack@suse.cz,
        vst@vlnb.net, linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        James.Bottomley@suse.de, chris.mason@oracle.com,
        konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, rwheeler@redhat.com,
        Christoph Hellwig <hch@lst.de>, Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [RFC] training mpath to discern between SCSI errors
References: <20100825155918.GB8509@redhat.com>	<4C7B984E.4070802@suse.de>	<4C7B9F14.9080900@mvista.com>	<4C7BA670.2060303@suse.de> <4C7BC5B4.3010707@suse.de> <4CBC00B3.7090603@ce.jp.nec.com>
In-Reply-To: <4CBC00B3.7090603@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 10:09 AM, Jun'ichi Nomura wrote:
> Hi Hannes,
> 
> Thank you for working on this issue and sorry for very late reply...
> 
> (08/30/10 23:52), Hannes Reinecke wrote:
>> From: Hannes Reinecke <hare@suse.de>
>> Date: Mon, 30 Aug 2010 16:21:10 +0200
>> Subject: [RFC][PATCH] scsi: Detailed I/O errors
>>
>> Instead of just passing 'EIO' for any I/O errors we should be
>> notifying the upper layers with some more details about the cause
>> of this error.
>> This patch updates the possible I/O errors to:
>>
>> - ENOLINK: Link failure between host and target
>> - EIO: Retryable I/O error
>> - EREMOTEIO: Non-retryable I/O error
>>
>> 'Retryable' in this context means that an I/O error _might_ be
>> restricted to the I_T_L nexus (vulgo: path), so retrying on another
>> nexus / path might succeed.
> 
> Does 'retryable' of EIO mean retryable in multipath layer?
> If so, what is the difference between EIO and ENOLINK?
> 
Yes, EIO is intended for errors which should be retried at the
multipath layer. This does _not_ include transport errors, which are
signalled by ENOLINK.

Basically, ENOLINK is a transport error, and EIO just means
something is wrong and we weren't able to classify it properly.
If we were, it'd be either ENOLINK or EREMOTEIO.

> I've heard of a case where just retrying within path-group is
> preferred to (relatively costly) switching group.
> So, if EIO (or other error code) can be used to indicate such type
> of errors, it's nice.
> 
Yes, that was one of the intention.

> 
> Also (although this might be a bit off topic from your patch),
> can we expand such a distinction to what should be logged?
> Currently, it's difficult to distinguish important SCSI/block errors
> and less important ones in kernel log.
> For example, when I get a link failure on sda, kernel prints something
> like below, regardless of whether the I/O is recovered by multipathing or not:
>   end_request: I/O error, dev sda, sector XXXXX
> 
Indeed, when using the above we could be modifying the above
message, eg by

end_request: transport error, dev sda, sector XXXXX

or

end_request: target error, dev sda, sector XXXXX

which would improve the output noticeable.

> Setting REQ_QUIET in dm-multipath could mask the message
> but also other important ones in SCSI.
> 
Hmm. Not sure about that, but I think the above modifications will
be useful already.

I'll be sending an updated patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
