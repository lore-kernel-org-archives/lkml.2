Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2EVUxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:53:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35608 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2EVUxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <4FBB0DB7.3040909@cn.fujitsu.com>
References: <4FB35C48.30708@cn.fujitsu.com>
	<CAG7+5M2nc3qPAS-GvX=YoVKqwdwSGdesoBQ6nsksHp2LFfzYcQ@mail.gmail.com>
	<4FBB0DB7.3040909@cn.fujitsu.com>
Date: Tue, 22 May 2012 13:53:47 -0700
Message-ID: <CAG7+5M3UZBevahU2T0+kESs4kn2Sbbg2fs_itKpVQ_Z8c9od3g@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
From: Eric Northup <digitaleric@google.com>
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 8:53 PM, Yanfei Zhang
<zhangyanfei@cn.fujitsu.com> wrote:
> 于 2012年05月22日 02:58, Eric Northup 写道:
[...]
>> So you can have the VMCS offset dumping be a manually-loaded module.
>> Build a database mapping from (CPUID, microcode revision) -> (VMCSINFO).
>> There's no need for anything beyond the (CPUID, microcode revision) to
>> be put in the kdump, since your offline processing of a kdump can then
>> look up the rest.
[...]
>
> We have considered this way, but there are two issues:
> 1) vmx resource is unique for a single cpu, and it's risky to grab it forcibly
> on the environment where kvm module is used, in particular on customer's environment.
> To do this safely, kvm support is needed.

It's not risky: you just have to make sure that no one else is going
to use the VMCS on your CPU while you're running.  You can disable
preemption and then save the old VMCS pointer from the CPU (see the
VMPTRST instructions).  Load your temporary VMCS pointer, discover
the fields, then restore the original VMCS pointer.  Then re-enable
preemption and you're done.
