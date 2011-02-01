Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1BALDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:03:15 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:57490 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1BALDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:03:14 -0500
Date: Tue, 1 Feb 2011 12:03:11 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] flex_array: Change behaviour on zero size allocations
Message-ID: <20110201110311.GM3070@secunet.com>
References: <20110131085213.GK3070@secunet.com>
 <1296491497.7797.3792.camel@nimitz>
 <20110201102417.GL3070@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201102417.GL3070@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Feb 2011 11:03:12.0289 (UTC) FILETIME=[9E107110:01CBC1FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:24:18AM +0100, Steffen Klassert wrote:
> 
> Both objections are correct, I'll send an updated patch.
> 

I think we need to fix selinux too to get rid of the policy loading
problem. In security/selinux/ss/policydb.c are several pieces of code
like this one:

p->type_val_to_struct_array = flex_array_alloc(sizeof(struct type_datum *),   
                                               p->p_types.nprim,              
                                               GFP_KERNEL | __GFP_ZERO);
if (!p->type_val_to_struct_array)      
	goto out;

rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
                         p->p_types.nprim - 1, GFP_KERNEL | __GFP_ZERO);
if (rc)
	goto out;

If p->p_types.nprim is zero, we allocare with total_nr_elements equal
to zerro and then we try to prealloc with p->p_types.nprim - 1.
flex_array_prealloc interprets this as an unsigned int and fails,
because this is bigger than total_nr_elements, which is correct I think.

Thoughts?

Steffen
