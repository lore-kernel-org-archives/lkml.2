Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0KJVYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:24:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49021 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab0KJVYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:24:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=M32r3ompuoxf9+Ktf+BYUYUbJDy4zDkf9HJe3YPVOmieN4Bxx5TIppfHK8s8nuCCYx
         +h9AcZ3c2dlUXGgT1qUZZ6j2MJXq/DlxkN6+5VohqBZ2oAztwvzGCcMVEATgNBwt6LNY
         V6BVqAqy8nWvdcpXS8d1pMqgpTWEyDzgTnlIk=
MIME-Version: 1.0
In-Reply-To: <4CDAFE4B.1060408@netapp.com>
References: <1289412737.4513.80.camel@e102109-lin.cambridge.arm.com>
	<4CDAFE4B.1060408@netapp.com>
Date: Wed, 10 Nov 2010 21:24:31 +0000
X-Google-Sender-Auth: EaPy4xv0H286TaDulSqUji9F8us
Message-ID: <AANLkTin4OtWZf_uWdFfCMqVyZoR_xm3-jmt0e7f04xc_@mail.gmail.com>
Subject: Re: Memory leak via nfs_readdir_make_qstr
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 November 2010 20:19, Bryan Schumaker <bjschuma@netapp.com> wrote:
> On 11/10/2010 01:12 PM, Catalin Marinas wrote:
>> I tested the 2.6.37-rc1 on an ARM platform with nfsroot filesystem.
>> Kmemleak reports quite a lot (> 150) of leaks like below. You seem to
>> have made changes recently to this area.
>>
> <snip>
>>
>> Any quick thoughts? I'll have a look tomorrow as well.
>
> My first thought is that this is because of how we are caching the result of a readdir now.  We are storing the name of each directory entry as part of the cache, and this requires allocating memory for each string.  These are freed on unmount (see nfs_readdir_clear_array() in fs/nfs/dir.c), but you probably don't want to unmount your root filesytem...

Ah, I got it now. It seems to be a kmemleak false positive since
kmemleak doesn't scan page cache pages. The easiest thing is to mark
the leak with kmemleak_not_leak(), with the disadvantage that if at
some point we get a real leak from the same place it will be missed.

If there is a function that gets called only once for each array
before it is populated (maybe nfs_do_filldir?), we could inform
kmemleak about this page so that it can scan it.

Thanks,

Catalin
