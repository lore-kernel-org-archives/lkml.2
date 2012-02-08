Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab2BHRCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:02:41 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:28314
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757278Ab2BHRCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:02:39 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzzz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F32AAA7.2040203@freescale.com>
Date: Wed, 8 Feb 2012 11:02:31 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: qemu-devel <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, KVM list <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>	<4F2C6517.3040203@codemonkey.ws> <4F302E0D.20302@freescale.com> <4F3118EA.7040302@codemonkey.ws>
In-Reply-To: <4F3118EA.7040302@codemonkey.ws>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 06:28 AM, Anthony Liguori wrote:
> On 02/06/2012 01:46 PM, Scott Wood wrote:
>> On 02/03/2012 04:52 PM, Anthony Liguori wrote:
>>> On 02/03/2012 12:07 PM, Eric Northup wrote:
>>>> How would the ability to use sys_kvm_* be regulated?
>>>
>>> Why should it be regulated?
>>>
>>> It's not a finite or privileged resource.
>>
>> You're exposing a large, complex kernel subsystem that does very
>> low-level things with the hardware.
> 
> As does the rest of the kernel.

Just because other parts of the kernel made this mistake (e.g.
networking) doesn't mean that KVM should as well.

> If you want finer grain access control, that's exactly why we have
> things like LSM and SELinux.  You can add the appropriate LSM hooks into
> the KVM infrastructure and setup default SELinux policies appropriately.

Needing to use such bandaids is more complicated (or at least less
familiar to many) than setting permissions on a filesystem object.

>> And sometimes it is a finite resource.  I don't know how x86 does it,
>> but on at least some powerpc hardware we have a finite, relatively small
>> number of hardware partition IDs.
> 
> But presumably this is per-core, right?

Not currently.

I can't speak for the IBM stuff, but our hardware is desgined with the
idea that a partition has a permanent system-wide LPID (partition ID).
We *may* be able to do dynamic LPID on e500mc, but it is likely to be a
problem in the future with things like LPID-based direct-to-guest
interrupt delivery.  There's also a question of prioritizing effort --
there's enough other stuff that needs work first.

> And they're recycled, right? 

Not currently (other than when a guest is destroyed, of course).

What are the advantages of getting rid of the file descriptor that
warrant this?  What is performance sensitive enough than an fd lookup is
unacceptable but the other overhead of going out to qemu is fine?

Is that fd lookup any heavier than "appropriate LSM hooks"?

If the fd overhead really is a problem, perhaps the fd could be retained
for setup operations, and omitted only on calls that require a vcpu to
have been already set up on the current thread?

-Scott

