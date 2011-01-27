Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab1A0Xlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:41:31 -0500
Received: from smtp-out.google.com ([74.125.121.67]:18179 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab1A0Xla convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:41:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=L8BGWuRD250gtisRzjur280zCUxjX/cczfytWGjMGQ3TaHG/3z3t36ZlVktM1+qX26
         rKBYmQCVBjI3mmNBWi8Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTimT_t-3smsaQUrtisFdkODfoOoroQ93tQ9PByBq@mail.gmail.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com> <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com> <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
 <AANLkTimT_t-3smsaQUrtisFdkODfoOoroQ93tQ9PByBq@mail.gmail.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 27 Jan 2011 15:41:06 -0800
Message-ID: <AANLkTim27Y+TKa54jhC1VuqXzjEzX150ysGoUKNJrBmk@mail.gmail.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 5:22 PM, Mike Waychison <mikew@google.com> wrote:
> On Wed, Jan 26, 2011 at 3:58 PM, Mike Waychison <mikew@google.com> wrote:
>> On Tue, Jan 25, 2011 at 6:46 PM, Greg KH <greg@kroah.com> wrote:
>>> So, let me ask, what specifically are you wanting to import/export
>>> to/from the kernel here?  Have you thought about other kernel/user apis
>>> instead of ioctls?  What is forcing you to use ioctls?
>>
>> I'm not sure if you are trying to suggest that there is a better way
>> to solve these problems without actually saying so.  We could probably
>> use a different interface, sure.
>>
>
> Well, I managed to find efivars.c, and it seems like I can probably
> massage it to do what I want as several of the calls I'd like to
> export to userland mirror portions of the EFI runtime services page.
> That won't take care of all of the firmware calls I'd like to export,
> but it's a start.
>

I've spent the last few hours looking at efivars.c and working out how
I can refactor it to reuse all the kobject bits it uses.  Does anybody
use this thing though?

I can't believe I was just lectured for crappy ABI when this thing
takes a binary packed struct on write() and process it:
   - without regard to write length, and
   - in a way that isn't compatible across compat (both DataSize and
Status are unsigned long!).

struct efi_variable {
        efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
        efi_guid_t    VendorGuid;
        unsigned long DataSize;
        __u8          Data[1024];
        efi_status_t  Status;
        __u32         Attributes;
} __attribute__((packed));

:(
