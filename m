Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1EFUJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:09:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1EFUJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aIQio/ooBluwXfSue/KoExSi95RokCXvMGeF9t266yHpV9XJfGdHNF5lxvosOVTpNd
         zjgz5BIZ4pMj8gFh/xIA==
MIME-Version: 1.0
In-Reply-To: <20110506200456.GA18229@emperor.us.dell.com>
References: <20110506125702.2585228b.randy.dunlap@oracle.com> <20110506200456.GA18229@emperor.us.dell.com>
From: Mike Waychison <mikew@google.com>
Date: Fri, 6 May 2011 15:09:22 -0500
Message-ID: <BANLkTinC10VapWniyuEE3RLgVRC6fm1EcQ@mail.gmail.com>
Subject: Re: [PATCH] efivars: prevent oops on unload when efi is not enabled
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        "matthew.e.tolentino@intel.com" <matthew.e.tolentino@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 3:04 PM, Matt Domsch <Matt_Domsch@dell.com> wrote:
> On Fri, May 06, 2011 at 02:57:02PM -0500, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> unregister_efivars() should check for efi_enabled and not undo
>> allocations when efi is not enabled.  Otherwise there is an Oops
>> during module unload:
>
> Thanks Randy.
>
> I'm not sure why the driver is still loaded at all if efi_enabled==0.
>
> static int __init
> efivars_init(void)
> {
> ...
>        if (!efi_enabled)
>                return 0;
>
>
>
> That return 0 should be return -ENODEV I think.  Mike?

Ya, I changed efivars so that others could still use the
register_efivars/unregister_efivars interfaces when !efi_enabled.
They are used by the drivers/firmware/google/gsmi.c driver currently
pending in linux-next.

I think the right approach in this case would be to do

        if (efi_enabled) {
               unregister_efivars(&__efivars);
               kobject_put(efi_kobj);
        }

in efivars_exit().

>
> Thanks,
> Matt
>
> --
> Matt Domsch
> Technology Strategist
> Dell | Office of the CTO
>
