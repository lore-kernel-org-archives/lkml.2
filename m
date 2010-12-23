Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0LWSvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 13:51:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46714 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0LWSve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bmcMjutH1JJMW/ETwPdqkcN6wr499VF8sn97BhV1wUhym7boRJknAU2TT9gF6Bm/BU
         R6+Fy4GxvMW6p6lsV5orGFyk0IGWRxrmTb+ACD8wvZwSdx1whx5iq+Yq6wayJQg5dNOR
         Pjw3jSItyrMjltyKsvRvqhCFz6fEnsngfJHBA=
MIME-Version: 1.0
In-Reply-To: <x49bp4c7555.fsf@segfault.boston.devel.redhat.com>
References: <20101220141553.GA6088@bitwizard.nl> <20101220190630.66084e1d@neptune.home>
 <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
 <20101222104306.GB30941@bitwizard.nl> <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
 <20101222224416.GE30941@bitwizard.nl> <x494oa48scp.fsf@segfault.boston.devel.redhat.com>
 <20101223170109.GA31591@bitwizard.nl> <x49bp4c7555.fsf@segfault.boston.devel.redhat.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 23 Dec 2010 13:51:13 -0500
Message-ID: <AANLkTikbhzopmyfbJuHUQdEBJLLP9e65n0cNBuUjhDdd@mail.gmail.com>
Subject: Re: Slow disks.
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 12:47 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
>
>> On Thu, Dec 23, 2010 at 09:40:54AM -0500, Jeff Moyer wrote:
>>> > In my performance calculations, 10ms average seek (should be around
>>> > 7), 4ms average rotational latency for a total of 14ms. This would
>>> > degrade for read-modify-write to 10+4+8 = 22ms. Still 10 times better
>>> > than what we observe: service times on the order of 200-300ms.
>>>
>>> I didn't say it would account for all of your degradation, just that it
>>> could affect performance.  I'm sorry if I wasn't clear on that.
>>
>> We can live with a "2x performance degradation" due to stupid
>> configuration. But not with the 10x -30x that we're seeing now.
>
> Wow.  I'm not willing to give up any performance due to
> misconfiguration!

I suspect a mailserver on a raid 5 with large chunksize could be a lot
worse than 2x slower.  But most of the blame is just raid 5.

ie.
write 4K from userspace

Kernel
Read old primary data, wait for data to actually arrive
Read old parity data, wait again
modify both for new data
write primary data to drive queue
write parity data to drive queue

userspace: fsync
kernel: force data from queues to drive (requires wait)


I'm guessing raid1 or raid10 would be several times faster.  And is at
least as robust as raid 5.

ie.
write 4K from userspace

Kernel
write 4K to first mirror's queue
write 4K to second mirror's queue
done

userspace: fsync
kernel: force data from queues to drive (requires wait)

Good Luck
Greg
