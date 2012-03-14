Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295Ab2CNSrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:47:39 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45004 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2CNSrf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:47:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120314132552.GC2304@redhat.com>
References: <4F606A7C.9090900@cn.fujitsu.com>
	<4F606DCC.3020908@redhat.com>
	<4F60726E.3090807@cn.fujitsu.com>
	<4F607325.6050607@redhat.com>
	<20120314104608.GU2304@redhat.com>
	<4F607789.4010109@redhat.com>
	<4F607CE4.2060809@cn.fujitsu.com>
	<4F609822.7050502@redhat.com>
	<20120314131415.GB2304@redhat.com>
	<4F609A15.5020902@redhat.com>
	<20120314132552.GC2304@redhat.com>
Date: Wed, 14 Mar 2012 11:47:33 -0700
Message-ID: <CAG7+5M2rLvPU=aA=7-KAv5vtqMBpOsW7WzFyMMD+nd=DndG7rQ@mail.gmail.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
From: Eric Northup <digitaleric@google.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Wen Congyang <wency@cn.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 6:25 AM, Gleb Natapov <gleb@redhat.com> wrote:
> On Wed, Mar 14, 2012 at 03:16:05PM +0200, Avi Kivity wrote:
>> On 03/14/2012 03:14 PM, Gleb Natapov wrote:
>> > On Wed, Mar 14, 2012 at 03:07:46PM +0200, Avi Kivity wrote:
>> > > On 03/14/2012 01:11 PM, Wen Congyang wrote:
>> > > > >
>> > > > > I don't think we want to use the driver.  Instead, have a small piece of
>> > > > > code that resets the device and pushes out a string (the panic message?)
>> > > > > without any interrupts etc.
>> > > > >
>> > > > > It's still going to be less reliable than a hypercall, I agree.
>> > > >
>> > > > Do you still want to use complicated and less reliable way?
>> > >
>> > > Are you willing to try it out and see how complicated it really is?
>> > >
>> > > While it's more complicated, it's also more flexible.  You can
>> > > communicate the panic message, whether the guest is attempting a kdump
>> > > and its own recovery or whether it wants the host to do it, etc., you
>> > > can communicate less severe failures like oopses.
>> > >
>> > hypercall can take arguments to achieve the same.
>>
>> It has to be designed in advance; and every time we notice something's
>> missing we have to update the host kernel.
>>
>
> We and in the designed stage now. Not to late to design something flexible
> :) Panic hypercall can take GPA of a buffer where host puts panic info
> as a parameter.  This buffer can be read by QEMU and passed to management.

If a host kernel change is in the works, I think it might be cleanest
to have the host kernel export a new kind of VCPU exit for
unhandled-by-KVM hypercalls.  Then usermode can respond to the
hypercall as appropriate.  This would permit adding or changing future
hypercalls without host kernel changes.

"Guest panic" is almost the definition of not-a-fast-path, and so
what's the reason to handle it in the host kernel.

Punting the functionality to user-space isn't a magic bullet for
getting a good interface designed, but in my opinion it is a better
place to be doing this.
