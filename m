Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1BVKLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:11:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1BVKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:11:48 -0500
Message-ID: <4D638BDE.70602@redhat.com>
Date: Tue, 22 Feb 2011 12:11:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
References: <4D57F677.3090004@redhat.com> <20110221172807.GD16508@amd.com>
In-Reply-To: <20110221172807.GD16508@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 07:28 PM, Roedel, Joerg wrote:
> >  - what's the cost of wrmsr(TSC_MULT)?
>
> Hard to tell by now because I only have numbers for pre-production
> hardware.

Can you ask your hardware people what the cost will likely be?  msrs are 
often expensive, and here we have two in the lightweight exit path.

> >  There are really two ways to implement this feature.  One is fully
> >  generic, like you did.  The other is to implement it at the host level -
> >  have a sysfs file and/or kernel parameter for the desired tsc frequency,
> >  write it once, and forget about it.  Trust management to set the host
> >  tsc frequency to the same value on all hosts in a migration cluster.
>
> The motivation here is mostly the flexibility. Scale the TSC for the
> whole migration cluster only makes sense if all hosts there support the
> feature. But the most likely scenario is that existing migration
> clusters will be extended by new machines and guests will be migrated
> there. And these guests should be able to see the same TSC frequency on
> the new host as the had on the old one. The older machines in the
> cluster may even have different TSC frequencys. With this flexible
> implementation those scenarios are possible. A host-wide setting for the
> scaling will make the feature useless in those (common) scenarios.

This doesn't really work, since we don't know on what host the TSC 
calibration loop ran:

- start guest on host H1
- migrate it around, now it's on host H2
- guest reboots, reruns calibration loop
- migrate it around some more, now it's on host H3
- migrate to host with tsc multiplier Hnew

So, what should we set the multiplier to? H1, H2, or H3's tsc rate?

-- 
error compiling committee.c: too many arguments to function

