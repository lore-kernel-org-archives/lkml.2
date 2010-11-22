Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0KVQzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:55:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59591 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab0KVQzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:55:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s5VUbXhlTXel1SA0xxwZVbTcP6PTpEIHKBZOd/7HFgITNGbXT5hQWYkFVLVs8HU/uQ
         eSHTvSFCRrDhQ6QLnercMGcYZpNJRCynrea5WwyQqjl7L2UH/q6STH+BUPYw5/lv3m8Z
         NtuK9XZ7KNA42wJb8rWKUNdCCGd6haRMmCDoM=
MIME-Version: 1.0
In-Reply-To: <1290391175.2903.132.camel@yhuang-dev>
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
	<1290391175.2903.132.camel@yhuang-dev>
Date: Mon, 22 Nov 2010 08:55:34 -0800
X-Google-Sender-Auth: 7Nazs40KFLDZoGDr-3_7eyymTkU
Message-ID: <AANLkTi=fNH4-VjLh1zzk-UdEQevR16_K8igdLeodw6yL@mail.gmail.com>
Subject: Re: [RFC] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 5:59 PM, Huang Ying <ying.huang@intel.com> wrote:
> This patch provides a general "read" interface for kmsg_dumper and some
> other persistent storage users. Another possible choice is to just
> extend the original interface to add persistent store support. For
> example, we can add a "read" function in kmsg_dumper, and output the
> content of persistent store via extend /dev/kmsg via prefix every line
> comes from persistent store or adding some "ioctl" to do that. (But it
> seems that nobody likes "ioctl").

In Linux (and Unix before it) "everything is a file" ... but this
doesn't work very well if the file has internal structure (e.g.
is made of records that can be individually changed or
deleted).  A filesystem seems a much better model.

>> "writer" which writes a record with a type to the persistent store
>
> I think it is necessary to require this to be NMI safe (in comments?),
> because hardware error handler may need to write to persistent storage
> in NMI context. Or we can add a "flag" field to let storage provider
> advocate its capability of NMI safe.

I can add a comment to pstore.h to document the NMI-safe
requirement for the "writer" function.

>>   - Which device(s) should error records be written to?
>>     All of them? Start with one and move on when it is
>>     full?  Write some types of records to one device?
>
> The persistent storage may be full, and the writing may fail. So I think
> we can just try to write one by one, until the first success writing.

A good option - if we ever find someone luck enough to have
more than one persistent store device.

>> +       sysfs_remove_bin_file(&pstore_kset->kobj, &search_pstore->attr);
>
> It seems that the corresponding memory is not freed after erasing.

Ouch!  Good catch.  Will add a kfree()

-Tony
