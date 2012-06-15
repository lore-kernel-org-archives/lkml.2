Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab2FODEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:04:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36654 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2FODEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:04:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Date: Fri, 15 Jun 2012 12:03:46 +0900 (JST)
Message-Id: <20120615.120346.21747125.d.hatayama@jp.fujitsu.com>
To: avi@redhat.com
Cc: zhangyanfei@cn.fujitsu.com, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, joerg.roedel@amd.com, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 3/5] KVM-INTEL: Add new module vmcsinfo-intel to
 fill VMCSINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4FD9E936.3030001@redhat.com>
References: <4FB35C48.30708@cn.fujitsu.com>
	<4FB35D60.6050009@cn.fujitsu.com>
	<4FD9E936.3030001@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM-INTEL: Add new module vmcsinfo-intel to fill VMCSINFO
Date: Thu, 14 Jun 2012 16:37:58 +0300

> On 05/16/2012 10:55 AM, zhangyanfei wrote:
<cut>
>> +
>> +/*
>> + * The format of VMCSINFO is given below:
>> + *   +-------------+--------------------------+
>> + *   | Byte offset | Contents                 |
>> + *   +-------------+--------------------------+
>> + *   | 0           | VMCS revision identifier |
>> + *   +-------------+--------------------------+
>> + *   | 4           | <field><encoded offset>  |
>> + *   +-------------+--------------------------+
>> + *   | 16          | <field><encoded offset>  |
>> + *   +-------------+--------------------------+
>> + *   ......
>> + *
>> + * The first 32 bits of VMCSINFO contains the VMCS revision
>> + * identifier.
>> + * The remainder of VMCSINFO is used for <field><encoded offset>
>> + * sets. Each set takes 12 bytes: field occupys 4 bytes
>> + * and its corresponding encoded offset occupys 8 bytes.
>> + *
>> + * Encoded offsets are raw values read by vmcs_read{16, 64, 32, l},
>> + * and they are all unsigned extended to 8 bytes for each
>> + * <field><encoded offset> set has the same size.
>> + * We do not decode offsets here. The decoding work is delayed
>> + * in userspace tools.
> 
> It's better to do the decoding here, or no one will know how to do it.
> Also have an nfields field.

We did so because actual internal format is unkown; it could possibly
be encrypted, although unlikely. We thought processing such unkown
data should have been done in userland debugging tools. But decoding
them here is no problem; the decode is of simple shift operations and
has no risk affecting system status, there's only possibility to
display broken values, which is same as the case displaying the
encrypted values for users.

FYI, the assumptions behind the reverse enginerring method are:

- For each field, the corresponding offset is unique; IOW, arbitrary
  two offsets for the corresponding two fields are different each
  other.
- Field size remains 8 bytes, 16 bytes, 32 bytes even on vmcs region.
- Each field is 8 byte alighed on vmcs region.
- Some fields may be big endition on vmcs region.
  - We found this fact under development. We give up if the data is
    modified more drastically.
- offset < vmcs region size

Thanks.
HATAYAMA, Daisuke

