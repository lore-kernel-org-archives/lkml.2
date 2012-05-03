Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2ECMNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:13:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2ECMNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:13:53 -0400
Message-ID: <4FA2767B.5010707@redhat.com>
Date: Thu, 03 May 2012 15:13:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet> <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com> <4FA0C8A7.9000001@linux.vnet.ibm.com> <20120502211031.GB12604@amt.cnet> <4FA27578.1010509@linux.vnet.ibm.com>
In-Reply-To: <4FA27578.1010509@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 03:09 PM, Xiao Guangrong wrote:
> Actually, the improvement of lockless is that it can let vcpu to be parallel
> as possible.
>
> From the test result, lockless gains little improvement for unix-migration,
> in this case, the vcpus are almost idle (at least not busy).
>
> The large improvement is from dbench-migration, in this case, all vcpus are
> busy accessing memory which is write-protected by dirty-log. If you enable
> page-fault/fast-page-fault tracepoints, you can see huge number of page fault
> from different vcpu during the migration.
>

We can kill the page faults completely by using A/D bits in shadow page
tables.  The latest version of the Intel SDM defines A/D bits for EPT,
and NPT has had them from day one.

Of course this comes at a cost, instead of traversing a bitmap we have
to read all sptes, which are 64x as large.  But it's probably worthwhile
for large guests and perhaps also for smaller ones.

-- 
error compiling committee.c: too many arguments to function

