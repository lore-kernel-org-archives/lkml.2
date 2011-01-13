Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1AMKyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:54:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61550 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab1AMKyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:54:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ta2n6QcZ3yhVZ2wH9bNzTYLW47oTLpcTvOwuFKpWFGR/Nrw7cPlTvtEDkCkQO6s3VE
         V/LYEWojyhVAP6REgs6wFNsr2o+M6kCvaQKnc74gyrxr5+3Psoke/ZMMB3AUMdDbf/Eo
         mQj3RuGjLsFfCfXo2bFeE4mfFJgOm0FXyTxBM=
MIME-Version: 1.0
In-Reply-To: <4D2ECC84.8050406@gmail.com>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
	<4D2ECB56.4070802@gmail.com>
	<4D2ECC84.8050406@gmail.com>
Date: Thu, 13 Jan 2011 21:54:11 +1100
Message-ID: <AANLkTin=CgtKcoC4fmsp_Fos35gPPsT-9+OvQvnov6MS@mail.gmail.com>
Subject: Re: WARNING: at fs/dcache.c:1359 d_set_d_op [was: mmotm
 2011-01-06-15-41 uploaded]
From: Nick Piggin <npiggin@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@linux.kernel.org,
        npiggin@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/13 Jiri Slaby <jirislaby@gmail.com>:
> On 01/13/2011 10:52 AM, Jiri Slaby wrote:
>> On 01/07/2011 12:41 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2011-01-06-15-41 has been uploaded to
>>
>> Hi, after some uptime and several suspend/resume cycles, I got:
>> WARNING: at fs/dcache.c:1359 d_set_d_op+0x82/0xb0()
>> Hardware name: To Be Filled By O.E.M.
>> Modules linked in: dvb_usb_af9015 tda18271 af9013 dvb_usb dvb_core
>> Pid: 3474, comm: automount Tainted: G        W   2.6.37-mm1_64+ #1344
>> Call Trace:
>>  [<ffffffff8106bd2a>] ? warn_slowpath_common+0x7a/0xb0
>>  [<ffffffff8106bd75>] ? warn_slowpath_null+0x15/0x20
>>  [<ffffffff81125a32>] ? d_set_d_op+0x82/0xb0
>>  [<ffffffff8120d829>] ? autofs4_dir_mkdir+0x169/0x180
>>  [<ffffffff8111caa8>] ? vfs_mkdir+0x78/0xa0
>>  [<ffffffff811209e6>] ? sys_mkdirat+0xf6/0x110
>>  [<ffffffff81120a13>] ? sys_mkdir+0x13/0x20
>>  [<ffffffff81030dbb>] ? system_call_fastpath+0x16/0x1b
>
> Note that even the second WARN was trigerred too:
> WARNING: at fs/dcache.c:1365 d_set_d_op+0x9e/0xb0()
> Hardware name: To Be Filled By O.E.M.
> flags=00004000
> Modules linked in: dvb_usb_af9015 tda18271 af9013 dvb_usb dvb_core
> Pid: 3474, comm: automount Tainted: G        W   2.6.37-mm1_64+ #1344
> Call Trace:
>  [<ffffffff8106bd2a>] ? warn_slowpath_common+0x7a/0xb0
>  [<ffffffff8106be01>] ? warn_slowpath_fmt+0x41/0x50
>  [<ffffffff81125a4e>] ? d_set_d_op+0x9e/0xb0
>  [<ffffffff8120d829>] ? autofs4_dir_mkdir+0x169/0x180
>  [<ffffffff8111caa8>] ? vfs_mkdir+0x78/0xa0
>  [<ffffffff811209e6>] ? sys_mkdirat+0xf6/0x110
>  [<ffffffff81120a13>] ? sys_mkdir+0x13/0x20
>  [<ffffffff81030dbb>] ? system_call_fastpath+0x16/0x1b
>
> My d_set_d_op looks like:
>        WARN_ON(dentry->d_op);
>        if (WARN(dentry->d_flags & (DCACHE_OP_HASH      |
>                                DCACHE_OP_COMPARE       |
>                                DCACHE_OP_REVALIDATE    |
>                                DCACHE_OP_REVALIDATE_RCU|
>                                DCACHE_OP_DELETE),
>                                "flags=%.8x", dentry->d_flags)) {
>                dentry->d_flags &= ~(DCACHE_OP_HASH | DCACHE_OP_COMPARE |
>                        DCACHE_OP_REVALIDATE | DCACHE_OP_REVALIDATE_RCU |
>                        DCACHE_OP_DELETE);
>        }
>
> So DCACHE_OP_REVALIDATE remained set.
>
>> I changed those BUG_ONs to WARN_ONs intentionally because I had problems
>> with that previously -- I had to:
>> dentry->d_flags &= ~(DCACHE_OP_HASH | DCACHE_OP_COMPARE |
>>       DCACHE_OP_REVALIDATE | DCACHE_OP_REVALIDATE_RCU |
>>       DCACHE_OP_DELETE);
>>
>> in d_set_d_op to not oops when calling NULLish op->d_delete later.

Thanks for reporting. I was a little over-optimistic in my assumption
that filesysystems
would be doing sane things with dentry->d_op.

Al has audited these guys and has a pull request pending.

In the meantime, avoiding the bug and flipping the bits off will work fine.

Thanks,
Nick
