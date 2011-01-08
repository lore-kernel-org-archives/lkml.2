Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1AHOBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 09:01:43 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:47983 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab1AHOBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 09:01:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S02rewlCgKU+Vjl3KjrhS2apyUyQ3IhFBVrkogLTA0J++dEm1IeP2mbrtGjVu3Xvbn
         8xxdOVLKoZeQSllvJw8VSKcNzt6k/7Kboj/x0sPwey3GjhSYIG35T7VkCRTa6RrIOqQC
         G/FrwONktaBGtVjM2ZfKa9miIF/zkC1ZehAeU=
Date: Sat, 8 Jan 2011 09:01:36 -0500
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace ida in workqueue with page-sized buffer
Message-ID: <20110108140136.GA13269@mtj.dyndns.org>
References: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Dec 18, 2010 at 09:10:18PM +0800, Hillf Danton wrote:
> The id of worker of global work queue is monitored with kernel library, ida.
> 
> The ida in global work queue is redefined to be page-sized buffer,
> which is allocated when initializing workqueue.
> 
> The new id allocator could monitor ids in the rage from 0 to INT_MAX.
> The buffer is used to store freed ids, and if the peak number of ids,
> in workqueue as whole, is not out of the capacity of the allocated
> buffer, there is no more allocation of buffer after initializing.
> 
> The advantage looks that the new allocator runs faster.

I'm confused about why this is necessary.  It's not like workqueue ID
alloc/dealloc is hot path to begin with (they're quite lazy) and
during worker creation / destruction ida is a quite insignificant
part, so what is it trying to optimize?  It's not like ida allocator
is slow to begin with.

Also, the allocator looks quite dubious.

* What happens if more entries than what can fit in a page are freed?
  It'll just lose track of it.

* ida guarantees that always the lowest available slot is allocated.
  The new allocator doesn't.

So, why oh why?

-- 
tejun
