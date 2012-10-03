Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab2JCADx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:03:53 -0400
Received: from server505d.appriver.com ([98.129.35.42]:63295 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932747Ab2JCADv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:03:51 -0400
X-Note-AR-ScanTimeLocal: 10/2/2012 7:03:51 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G321 G322 G323 G324 G328 G329 G340 G436 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 2 Oct 2012 19:03:48 -0500
Subject: Re: [PATCH 1/7] aoe: support more AoE addresses with dynamic block
 device minor numbers
Thread-Topic: [PATCH 1/7] aoe: support more AoE addresses with dynamic block
 device minor numbers
Thread-Index: Ac2g+pEQ5VTMoxDrR+yhmxTZxVS/IQ==
Message-ID: <EC30E724-B84C-425D-BFF0-90DCC8FB17AB@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
 <20121002141230.17f59ed8.akpm@linux-foundation.org>
In-Reply-To: <20121002141230.17f59ed8.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 2, 2012, at 5:12 PM, Andrew Morton wrote:
...
>> +static int
>> +minor_get(ulong *minor)
>> {
>> -	struct aoedev *d;
>> 	ulong flags;
>> +	ulong n;
>> +	int error = 0;
>> +
>> +	spin_lock_irqsave(&used_minors_lock, flags);
>> +	n = find_first_zero_bit(used_minors, N_DEVS);
>> +	if (n < N_DEVS)
>> +		set_bit(n, used_minors);
>> +	else
>> +		error = -1;
>> +	spin_unlock_irqrestore(&used_minors_lock, flags);
>> +
>> +	*minor = n * AOE_PARTITIONS;
>> +	return error;
>> +}
> 
> - can use the more efficient __set_bit() inside that spinlock.

Thanks for that observation.  Because this operation occurs on target discovery, which is expected to be relatively infrequent, my inclination is to leave it in its atomic form, though, and leave the __set_bit() for another time when optimization is needed.  Like you said, this is a minor point.  I wouldn't mind changing it, though, if you think it's worth me resubmitting the patch.  Just let me know.

> - could avoid setting *minor if we're returning an error.

Yes.  The only caller of aoedev.c:minor_get() handles that correctly.  Again, just let me know if you think this is worth a resubmission of the patch.  Otherwise I'll just make a note to myself to try to avoid setting output parameters on error in the future.

-- 
  Ed Cashin
  ecashin@coraid.com


