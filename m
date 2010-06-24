Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0FXJfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:35:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:30171 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab0FXJfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=content-type:mime-version:subject:from:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=BDoOpCUOV3WYJzMPj2S8Q9xP+TUr3hYVQvl0OHcsrj+SCh/POyXE2yKehyUQAh+Osg
         Ns8FUi8YdREFh/CG7LXVTPhaxxWgTaNRG2imjcWhdSpJiXXUgyZORIIeRoFxv4ninzbM
         uSvz3HQd/M2IAlf4mgmmAK5Xaja2NcJUMfYEA=
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Apple Message framework v1081)
Subject: Fwd: [PATCH] Staging: memrar: Moved memrar_allocator struct into memrar_allocator.c
From: "=?iso-8859-1?Q?Henri_H=E4kkinen?=" <henrih81@gmail.com>
Date: Thu, 24 Jun 2010 12:35:19 +0300
Cc: gregkh@suse.de, ossama.othman@intel.com,
       Matti Lammi <mattij.lammi@gmail.com>, randy.dunlap@oracle.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1C8E6A7A-45FE-4862-A6AD-397548588F96@gmail.com>
References: <A5FE05C4C76E4C4CAB15D9962B96FC950CEA180A03@orsmsx510.amr.corp.intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.6.2010, at 12.09, Alan Cox wrote:

>> size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
>> {
>> -	if (allocator == NULL)
>> -		return 0;
>> -	return allocator->largest_free_area;
>> +	size_t tmp = 0;
>> +
>> +	if (allocator != NULL) {
>> +		mutex_lock(&allocator->lock);
>> +		tmp = allocator->largest_free_area;
>> +		mutex_unlock(&allocator->lock);
> 
> This doesn't seem to make any sense (in either version). The moment you
> drop the lock the value in "tmp" becomes stale as the allocator could
> change it. ?
> 

The idea was proposed by Ossama Othman in his earlier reply.


Begin forwarded message:

> From: "Othman, Ossama" <ossama.othman@intel.com>
> To: Henri Häkkinen <henuxd@gmail.com>, "gregkh@suse.de" <gregkh@suse.de>, "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>, "alan@linux.intel.com" <alan@linux.intel.com>
> Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Subject: RE: [PATCH] Staging: memrar: Moved memrar_allocator struct into memrar_allocator.c
> 
> Hi,
> 
>> Forward declared memrar_allocator in memrar_allocator.h and moved it
>> to memrar_allocator.c file.  Implemented memrar_allocator_capacity(),
>> memrar_allocator_largest_free_area(), memrar_allocoator_lock() and
>> memrar_allocator_unlock().
> ...
>> -	mutex_lock(&allocator->lock);
>> -	r->largest_block_size = allocator->largest_free_area;
>> -	mutex_unlock(&allocator->lock);
>> +	memrar_allocator_lock(allocator);
>> +	r->largest_block_size =
>> memrar_allocator_largest_free_area(allocator);
>> +	memrar_allocator_unlock(allocator);
> 
> I don't think it's necessary to expose the allocator lock.  Why not just grab the lock in memrar_allocator_largest_free_area() while the underlying struct field is being accessed and then unlock it before that function returns?  That would allow the allocator lock to remain an internal implementation detail.  We only need to ensure access to the struct field itself is synchronized, e.g.:
> 
> size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
> {
> 	size_t tmp = 0;
> 
> 	if (allocator != NULL) {
> 		mutex_lock(&allocator->lock);
> 		tmp = allocator->largest_free_area;
> 		mutex_unlock(&allocator->lock);
> 	}
> 
> 	return tmp;
> }
> 
> Certainly the allocator->largest_free_area value could be updated after the lock is released and by the time it is returned to the user (for statistical purposes), but at least the internal allocator state would remain consistent in the presences of multiple threads.
> 
> HTH,
> -Ossama
> 

