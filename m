Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1ITW7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 18:59:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1ITW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 18:59:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=UoCU6mXT+cAXK6LZ3M8ywJmjLgd6WZDt/dX63+LM1yJ+sTfsT2hxlREZEG2WANGCH
	D99GVbjN1PgeXNLPfXLgA==
Date: Tue, 20 Sep 2011 15:59:12 -0700
From: Andrew Morton <akpm@google.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] kdump: Initialize vmcoreinfo note at startup
Message-Id: <20110920155912.d107fd49.akpm@google.com>
In-Reply-To: <20110920143436.019045253@linux.vnet.ibm.com>
References: <20110920143400.776127689@linux.vnet.ibm.com>
	<20110920143436.019045253@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 16:34:01 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently the vmcoreinfo note is only initialized in case of kdump. On s390
> it is possible to create kernel dumps with other dump mechanisms than kdump
> (e.g. via hypervisor dump or stand-alone dump tools). For those dumps it
> would also be desirable to include the vmcoreinfo data. To accomplish this,
> with this patch the vmcoreinfo ELF note is always initialized, not only in
> case of a (kdump) crash. On s390 we will add an ABI defined pointer at
> a well known address to vmcoreinfo so that dump analysis tools are able to
> find this information.
> 
> In particular on s390 we have a tool named zgetdump. With this tool it is
> possible to convert dump formats on the fly using fuse. E.g. you can mount a
> s390 stand-alone dump as ELF dump. When this is done, the tool finds the
> vmcoreinfo in the stand-alone dump via the well known ABI defined address and
> it creates the respective VMCOREINFO ELF note in the output ELF dump. This then
> can be used e.g. by makedumpfile for dump filtering.  No more need for a
> vmlinux file with debug information.
> 
> So this will look like the following:
> $ zgetdump --mount standalone.dump -f elf /mnt
> $ ls /mnt
>   dump.elf
> $ readelf -n /mnt/dump.elf
> $ ...
>   VMCOREINFO            0x00000474      Unknown note type: (0x00000000)
> $ makedumpfile -c -d 31 /mnt/dump.elf dump.kdump
> 
> ...
>
> -void crash_save_vmcoreinfo(void)
> +static void update_vmcoreinfo_note(void)
>  {
> -	u32 *buf;
> +	u32 *buf = (u32 *) vmcoreinfo_note;

The cast is unneeded?

>  	if (!vmcoreinfo_size)
>  		return;
> -
> -	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
> -
> -	buf = (u32 *)vmcoreinfo_note;

As was the space you added after it ;)

>  	buf = append_elf_note(buf, VMCOREINFO_NOTE_NAME, 0, vmcoreinfo_data,
>  			      vmcoreinfo_size);
> -
>  	final_note(buf);
>  }

