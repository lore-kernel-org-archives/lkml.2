Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0DNFSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:18:33 -0400
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:37961 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0DNFSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:18:31 -0400
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Date: Wed, 14 Apr 2010 07:18:20 +0200
From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge@Sun.COM>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
In-reply-to: <1271181774.4807.1868.camel@twins>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roland Dreier <rdreier@cisco.com>,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rdma@vger.kernel.org, rolandd@cisco.com, pavel@ucw.cz,
       mingo@elte.hu, jsquyres@cisco.com
Message-id: <06A5381F-9D03-4854-ABEB-B2025620E379@Sun.COM>
X-Mailer: Apple Mail (2.1078)
Content-transfer-encoding: 8BIT
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
 <adahbnfme0j.fsf@roland-alpha.cisco.com> <1271181774.4807.1868.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 13, 2010, at 20:02 , Peter Zijlstra wrote:

> 
> Yeah, virtual<->physical maps can change through swapping, page
> migration, memory compaction, huge-page aggregation (the latter two not
> yet being upstream).

Assuming this holds true, RDMA will not work. And with no RDMA, we do not need ummunotify. Is that your argument?

Seriously, RDMA requires the virtual to physical mapping to remain constant for a period of time. And that time period is from memory registration to de-registration. If the virtual to physical mapping changes in that period for the registered memory area, I can't see how an HCA can handle that.

For MPI applications, the MPI API defines that the buffers used in communication cannot be changed or freed while a non-blocking transfer is in progress. So far, we are good. But memory registration (and in particular de-registration) is a costly process. Since MPI is about performance, the MPI library would like to  re-use earlier memory registrations for other transfers. The MPI library records earlier memory mappings (VA+bound) and checks if the VA+bound of a new transfer is already contained in memory revisions registered earlier.

The problem with this approach is that _normal_ activity _between_ the transfers changes the virtual to physical mapping and ruins previous memory registrations. The problem is to catch these. I simply argue that they should be caught the simplest possible way; a call-back from the system calls affecting the virtual to physical mapping.

> 
> Even mlock() doesn't pin virtual<->physical maps.

Can you elaborate on what you mean here?


Thanks, Håkon

