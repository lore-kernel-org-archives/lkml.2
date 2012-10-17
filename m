Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2JQC3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:29:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16342 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab2JQC3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:29:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,597,1344182400"; 
   d="scan'208";a="6011682"
Message-ID: <507E17C0.9070305@cn.fujitsu.com>
Date: Wed, 17 Oct 2012 10:28:16 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: x86@kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] x86: clear vmcss on all cpus when doing kdump if
 necessary
References: <5077BB7B.4030203@cn.fujitsu.com> <507C2F18.8080904@redhat.com>
In-Reply-To: <507C2F18.8080904@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 10:29:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/17 10:29:13
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年10月15日 23:43, Avi Kivity 写道:
> On 10/12/2012 08:40 AM, Zhang Yanfei wrote:
>> Currently, kdump just makes all the logical processors leave VMX operation by
>> executing VMXOFF instruction, so any VMCSs active on the logical processors may
>> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
>> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
>> executing the VMXOFF instruction.
> 
> How have you verified that VMXOFF doesn't flush cached VMCSs already?
> 

I tried some tests, for example, I made copies for every vmcs, and in the kdump
path, I backed up all the loaded vmcs into the copies before vmxoff.
After generating the vmcore, I retrieve the vmcss and their copies, and compare them,
no differences.

Another test is using VMCLEAR to clear all the loaded vmcs before VMXOFF,
and compare the vmcss and their copies, there are indeed differences between the
vmcs and its copy.

I know the tests may be not so convincing, for example, I used memcpy to back up
the vmcss and it is an ordinary memory operation. But to ensure the non-corruption
of the vmcss in the vmcore, I think we should VMCLEAR the vmcss before VMXOFF just
as the Intel spec says.

>>
>> The patch set provides an alternative way to clear VMCSs related to guests
>> on all cpus when host is doing kdump.
>>
> 
> I'm not sure the sysctl is really necessary.  The only reason to turn if
> off is if the corruption is so severe that the loaded vmcs list itself
> causes a crash.  I think it should be rare enough that we can do it
> unconditionally.
> 

You mean not using sysctl and just let VMCLEAR-VMCSS be a default behaviour? If so,
I agree with you.

Thanks
Zhang Yanfei

