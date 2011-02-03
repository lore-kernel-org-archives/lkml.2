Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1BCJ2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:28:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62560 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1BCJ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:28:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q6L4t6/0eA14ZVDTkGw7hRr3Xbrfzuvss7JLoy9aUdD62ZSTk/capj5Dv1WpQune32
         U0NuUTi1VdUJApIRc8SA3v3/mHYgkgyahYtvfjSQ5Uv8Xfw3YN0PCW2F4crQakX2HsNj
         oZ98gBl+IBXZlZXoyL6Scs0aNH9CsCkRDddp4=
Date: Thu, 3 Feb 2011 10:28:23 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, tytso@mit.edu, djwong@us.ibm.com,
        shli@kernel.org, neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        linux-kernel@vger.kernel.org, kmannth@us.ibm.com, cmm@us.ibm.com,
        linux-ext4@vger.kernel.org, rwheeler@redhat.com, hch@lst.de,
        josef@redhat.com, jmoyer@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Message-ID: <20110203092823.GB2570@htj.dyndns.org>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202225549.GA28109@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 02, 2011 at 05:55:49PM -0500, Mike Snitzer wrote:
> @@ -808,9 +808,14 @@ static struct request *get_request(struc
>  	rl->count[is_sync]++;
>  	rl->starved[is_sync] = 0;
>  
> -	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> -	if (priv)
> -		rl->elvpriv++;
> +	/*
> +	 * Only initialize elevator data if REQ_SORTED is set.
> +	 */
> +	if (rw_flags & REQ_SORTED) {
> +		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
> +		if (priv)
> +			rl->elvpriv++;
> +	}

This isn't enough.  Now the allocated requests would have REQ_SORTED
set before going into elevator.  You probably want to filter out
REQ_SORTED to elv_may_queue() too.

Also, it would be great if you update the comment on top of
get_request() to explain what @rw_flags does.

Thank you.

-- 
tejun
