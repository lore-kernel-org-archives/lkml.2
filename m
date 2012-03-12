Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2CLMNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab2CLMNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:13:06 -0400
Message-ID: <4F5DE84B.8050606@redhat.com>
Date: Mon, 12 Mar 2012 14:12:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Davidlohr Bueso <dave@gnu.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: x86: add paging gcc optimization
References: <1331207154.28711.2.camel@offworld> <4F58D48F.8050807@de.ibm.com>
In-Reply-To: <4F58D48F.8050807@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 05:47 PM, Christian Borntraeger wrote:
> On 08/03/12 12:45, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > Since most guests will have paging enabled for memory management, add likely() optimization
> > around CR0.PG checks.
>
> >  {
> > -	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
> > +	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
>
>
> IMHO likely/unlikely should be considered more as fast-path/slow-path and not as often/less often.

Agree.

> Is that the case here? This patch  might cause a mis-prediction for non-paging guests all 
> the time. 
>
> Non-paging might be really irrelevant, so I am just making a point, since
> likely/unlikely is mis-used too often especially for "most users do it that way".

In fact this is a classic example.  Almost no guests use real mode (the
last guests to use real mode extensively was DOS; I think Win9x switches
to real mode pretty often).  As it's a user-controlled setting, we're
penalizing users who do things differently.

However the majority if is_paging() == true guests is so huge, and since
non-paging guests don't really expect 2012 performance levels anyway
(being so old) that I think in practice this is a good optimization here.

-- 
error compiling committee.c: too many arguments to function

