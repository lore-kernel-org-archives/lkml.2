Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1C3Hl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:41:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47996 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1C3Hl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w0OJKU9hFEK8pasROm+8Fty/7cK9NNlZKW79awXjbLdljG3EwckOiVQxEsaRuZwqho
         DUizESH/YmPwrqtMEr+IDM7UyeynDwfdwYJIgaJ4dSTYvUlkQ8a9K/RuFXIRMJUgUdWT
         CPkKy2pruvbHnVRMRoU55IOwpXZjUAg1EQMb8=
Date: Wed, 30 Mar 2011 09:41:23 +0200
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE (was: Re:
 elevator private data for REQ_FLUSH)
Message-ID: <20110330074123.GA17523@htj.dyndns.org>
References: <20110325152228.GA1707@gentoo.trippels.de>
 <20110325154024.GA16029@redhat.com>
 <4D8CB9C9.5010208@kernel.dk>
 <20110325185455.GA2969@redhat.com>
 <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329175458.GE24485@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 01:54:58PM -0400, Vivek Goyal wrote:
> What is the significance of REQ_SOFTBARRIER? Why it should be set for all
> INSERT_FRONT and requeue requests.
> 
> With flush logic we got rid of all hardbarriers and hence there is no
> notion of ordering as such. One has to wait for request to finish to
> enforce ordering.
> 
> Should we get rid of softbarriers too?

REQ_SOFTBARRIER makes sure that other requests don't pass the barrier
ones when dispatched from the elevator to the dispatch queue.  When
the request is being inserted explicitly at front, dispatching other
requests in front of it is a bit, umm, weird.

IIRC, at least in the requeue path, some drivers depend on front
queueing for forward progress guarantee.  Forward progress for
prepping is guaranteed by mempool (or something like that) and when
the request is retried, it should stay at the front of the queue;
otherwise, prepping can stall with prepped requests stuck behind
unprepped ones.

Although flush requests don't need REQ_SOFTBARRIER anymore, I don't
think removing it would bring much benefit either, so no reason to
change it just for that reason.

Thanks.

-- 
tejun
