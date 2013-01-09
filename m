Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3AIEO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 23:14:57 -0500
Received: from mail-ie0-f187.google.com ([209.85.223.187]:38903 "EHLO
	mail-ie0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3AIEO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 23:14:56 -0500
X-Greylist: delayed 36631 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 23:14:56 EST
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Tue, 8 Jan 2013 20:14:55 -0800 (PST)
In-Reply-To: <fa.h/6oWR6kmOBuicuev7/0gdVAyU4@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=122.167.45.138;
 posting-account=NCRxaQoAAAD54XcIcQi1OXMFZuM4f-KP
NNTP-Posting-Host: 122.167.45.138
References: <fa.Y0FHvNmq3PUOPFTOjxSNqjMULHc@ifi.uio.no> <fa.brRV/ZItJPfVkucfEAnS6B1Vfow@ifi.uio.no>
 <fa.h/6oWR6kmOBuicuev7/0gdVAyU4@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 122.167.45.138
MIME-Version: 1.0
Message-ID: <f419d12f-2594-43c3-b894-f4d4c21a3166@googlegroups.com>
Subject: Re: [block] allow blk_flush_policy to return REQ_FSEQ_DATA
 independent of *FLUSH
From: Ajith Kumar <ajithb.kumar@gmail.com>
To: fa.linux.kernel@googlegroups.com
Cc: ajithb.kumar@gmail.com, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Thanks for the response.
A block device driver during initialization would decide if it is capable of supporting FLUSH/FUA or not.  Suppose driver claims FLUSH/FUA support then any bio targeted at this driver with FLUSH bit set(which is commonly set by file system like XFS for doing internal logging) has a data corruption vulnerability in case of an abrupt shutdown.  So, IMO the vulnerability is not open to rare window where driver changes q->flush_flags while IO is in flight, but for a much larger window from time driver comes up and throughout it's life.

Thanks,
Ajith

On Wednesday, 9 January 2013 00:15:31 UTC+5:30, Tejun Heo  wrote:
> Hello,
> 
> 
> 
> On Tue, Jan 08, 2013 at 10:04:23AM -0800, ajithb.kumar@gmail.com wrote:
> 
> > Hi,
> 
> > Could you please provide clarity on the following.
> 
> > ">   Hmmm... yes, this can become a correctness issue if (and only if)
> 
> > >   blk_queue_flush() is called to change q->flush_flags while requests
> 
> > >   are in-flight;"
> 
> >
> 
> > Could you please clarify as to why is it a correctness issue only if
> 
> > blk_queue_flush() is used to change flush_flags when requests are in
> 
> > flight ?  As I understand, XFS does set WRITE_FLUSH_FUA flag in
> 
> > _xfs_buf_ioapply() function irrespective of whether the underlying
> 
> > device supports flush capabilities or not which will flow into
> 
> > blk_insert_flush().  Is my reading of the code correct and is there
> 
> > a general correctness issue here which potentially results in XFS
> 
> > file system corruption in case of an abrupt shutdown independent of
> 
> > q->flush_flags getting changed while request is in flight.
> 
> 
> 
> My memory is kinda fuzzy at this point but if a queue doesn't support
> 
> flush, its flush_flags should be zero and
> 
> generic_make_request_checks() will clear REQ_FLUSH|REQ_FUA from
> 
> bio->bi_rw so we never hit blk_insert_flush() and the request will be
> 
> processed as a normal IO one; however, if REQ_FLUSH goes off after a
> 
> request passed generic_make_request_checks() but before
> 
> blk_flush_policy(), it'll become null op and its data payload won't
> 
> get written out to the underlying device, which is data corruption.
> 
> 
> 
> Thanks.
> 
> 
> 
> -- 
> 
> tejun
> 
> --
> 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> 
> the body of a message to majordomo@vger.kernel.org
> 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Please read the FAQ at  http://www.tux.org/lkml/

