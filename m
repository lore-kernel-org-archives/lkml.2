Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2HDWgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 18:36:50 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40218 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab2HDWgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 18:36:48 -0400
Message-ID: <501DA3F0.4090009@cs.wisc.edu>
Date: Sat, 04 Aug 2012 17:36:32 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Chanho Min <chanho0207@gmail.com>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] fix NULL-pointer dereference on scsi_run_queue
References: <CAOAMb1D+g0zzKGKjMPPp7V-XEwKB5AYGMDvUUbXNaHaz8ieTVg@mail.gmail.com> <501CE4E5.20604@acm.org> <501D51D1.2010806@cs.wisc.edu> <501D83A1.7040900@acm.org>
In-Reply-To: <501D83A1.7040900@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 03:18 PM, Bart Van Assche wrote:
> On 08/04/12 16:46, Mike Christie wrote:
>> I think we have to have scsi-ml do a get_device when a sdev is added to
>> the starved entry and then do a put_device when it is removed (must do
>> these under the host lock for the starved entry case too). I am not sure
>> if that is just a hack/papering-over of the problem and there are more
>> issues like this.
> 
> That would result in a more complex patch than the patch at the start of
> this thread, isn't it ? Also, IMHO it would help to document which

Yaah, but the original patch in this thread is still racey isn't it?

 		spin_unlock(shost->host_lock);

The sdev/queue could get freed by some other thread when this function
is right here, so the get_device call is now going to try to access
freed memory.


+		/* hold a reference on the device so it doesn't release device */
+		get_device(&sdev->sdev_gendev);


