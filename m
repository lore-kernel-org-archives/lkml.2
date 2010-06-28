Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab0F1Jnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:43:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab0F1Jnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:43:42 -0400
Message-ID: <4C286ECA.1030806@redhat.com>
Date: Mon, 28 Jun 2010 12:43:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/10] KVM: MMU: fix conflict access permissions in
 direct sp
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249B93.9040907@cn.fujitsu.com>
In-Reply-To: <4C249B93.9040907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 03:05 PM, Xiao Guangrong wrote:
> In no-direct mapping, we mark sp is 'direct' when we mapping the
> guest's larger page, but its access is encoded form upper page-struct
> entire not include the last mapping, it will cause access conflict.
>
> For example, have this mapping:
>          [W]
>        / PDE1 ->  |---|
>    P[W]          |   | LPA
>        \ PDE2 ->  |---|
>          [R]
>
> P have two children, PDE1 and PDE2, both PDE1 and PDE2 mapping the
> same lage page(LPA). The P's access is WR, PDE1's access is WR,
> PDE2's access is RO(just consider read-write permissions here)
>
> When guest access PDE1, we will create a direct sp for LPA, the sp's
> access is from P, is W, then we will mark the ptes is W in this sp.
>
> Then, guest access PDE2, we will find LPA's shadow page, is the same as
> PDE's, and mark the ptes is RO.
>
> So, if guest access PDE1, the incorrect #PF is occured.
>
> Fixed by encode the last mapping access into direct shadow page
>
> And, it also cleanup the code that directly get the last level's dirty flag
>
>    

Looks good, but please split the cleanup from the fix (we'll want to 
backport the fix but not the cleanup).

-- 
error compiling committee.c: too many arguments to function

