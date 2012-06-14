Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2FNNiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065Ab2FNNiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:38:13 -0400
Message-ID: <4FD9E936.3030001@redhat.com>
Date: Thu, 14 Jun 2012 16:37:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 3/5] KVM-INTEL: Add new module vmcsinfo-intel to fill
 VMCSINFO
References: <4FB35C48.30708@cn.fujitsu.com> <4FB35D60.6050009@cn.fujitsu.com>
In-Reply-To: <4FB35D60.6050009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 10:55 AM, zhangyanfei wrote:
> This patch implements a new module named vmcsinfo-intel. The
> module fills VMCSINFO with the VMCS revision identifier,
> and encoded offsets of VMCS fields.
> 
> Note, offsets of fields below will not be filled into VMCSINFO:
> 1. fields defined in Intel specification (Intel® 64 and
>    IA-32 Architectures Software Developer’s Manual, Volume
>    3C) but not defined in *vmcs_field*.
> 2. fields don't exist because their corresponding control bits
>    are not set.
> 
> +
> +/*
> + * We separate these five control fields from other fields
> + * because some fields only exist on processors that support
> + * the 1-setting of control bits in the five control fields.
> + */

I thought this was checked only during VMENTRY.  So perhaps you don't
need this special casing.

In fact you might be able to

   // pre-fill vmcs with patterns

  for (i = 0; i < 64k; ++i)
      if (vmcs_read_checking(i, &pattern)) {
           // decode pattern
      } else
           // field does not exist (VM Instruction error 12), ignore

with no knowledge of the control fields, or of any field name.


> +
> +/*
> + * The format of VMCSINFO is given below:
> + *   +-------------+--------------------------+
> + *   | Byte offset | Contents                 |
> + *   +-------------+--------------------------+
> + *   | 0           | VMCS revision identifier |
> + *   +-------------+--------------------------+
> + *   | 4           | <field><encoded offset>  |
> + *   +-------------+--------------------------+
> + *   | 16          | <field><encoded offset>  |
> + *   +-------------+--------------------------+
> + *   ......
> + *
> + * The first 32 bits of VMCSINFO contains the VMCS revision
> + * identifier.
> + * The remainder of VMCSINFO is used for <field><encoded offset>
> + * sets. Each set takes 12 bytes: field occupys 4 bytes
> + * and its corresponding encoded offset occupys 8 bytes.
> + *
> + * Encoded offsets are raw values read by vmcs_read{16, 64, 32, l},
> + * and they are all unsigned extended to 8 bytes for each
> + * <field><encoded offset> set has the same size.
> + * We do not decode offsets here. The decoding work is delayed
> + * in userspace tools.

It's better to do the decoding here, or no one will know how to do it.
Also have an nfields field.
-- 
error compiling committee.c: too many arguments to function


