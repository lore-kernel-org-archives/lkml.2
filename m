Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0HYJko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:40:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46947 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0HYJkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VS6HqDooQzUn156/fOsZfmdSrApObUB+WMNeeIEHqfRiYF8loYU7gKFJMeMFYzWIOR
         KvlFK2snrDFX5an7WCY0uvuIT2DjzirCZLsD1Br21aBB8WfHmGGgEYLiCHhUP9cwambk
         E0Du68c6Ng7eFNpRn8InECtkMTMKaMH59Ap0c=
MIME-Version: 1.0
In-Reply-To: <1282594125.3111.344.camel@localhost.localdomain>
References: <cover.1281956490.git.richard.cochran@omicron.at>
	<363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
	<AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
	<20100817085324.GB3330@riccoc20.at.omicron.at>
	<1282090963.1734.97.camel@localhost>
	<20100818071942.GA4096@riccoc20.at.omicron.at>
	<1282176776.2865.100.camel@localhost.localdomain>
	<20100819055518.GA4084@riccoc20.at.omicron.at>
	<1282594125.3111.344.camel@localhost.localdomain>
Date: Wed, 25 Aug 2010 11:40:40 +0200
X-Google-Sender-Auth: GiHuR7BxmG3RTgAfXCEQXs-YZJ8
Message-ID: <AANLkTi=nKrRHH6+9mvny718gov8Q+u7DHFikdgNY8YdX@mail.gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
From: Christian Riesch <christian.riesch@omicron.at>
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:08 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Thu, 2010-08-19 at 07:55 +0200, Richard Cochran wrote:
>> On Wed, Aug 18, 2010 at 05:12:56PM -0700, john stultz wrote:
>> > Again, my knowledge in the networking stack is pretty limited. But it
>> > would seem that having an interface that does something to the effect of
>> > "adjust the timestamp clock on the hardware that generated it from this
>> > packet by Xppb" would feel like the right level of abstraction. Its
>> > closely related to SO_TIMESTAMP, option right? Would something like
>> > using the setsockopt/getsockopt interface with
>> > SO_TIMESTAMP_ADJUST/OFFSET/SET/etc be reasonable?
>>
>> The clock and its adjustment have nothing to do with a network
>> socket. The current PTP hacks floating around all add private ioctls
>> to the MAC driver. That is the *wrong* way to do it.
>
> Could you clarify on *why* that is the wrong approach?
>
> Maybe this is where some of the confusion is coming from? The subtleties
> of the more generic PTP algorithm and how the existence of PTP hardware
> clocks change things are not clear to me. My understanding of ptp and
> the networking details around it is limited, so your expertise is
> appreciated.  Might you consider covering some of this via a
> Documentation/ptp/overview.txt file in a future version of your patch?
>
> Here's a summary of what I understand:
> So from:
> http://en.wikipedia.org/wiki/Precision_Time_Protocol#Synchronization
>
> We see the message exchange of Sync/Delay_Req/Delay_Resp, and the
> calculation of the local offset from the server (and then a frequency
> adjustment over time as offsets values are accumulated).
>
> Without the hardware clock, this all of these messages and their
> corresponding timestamps are likely created by PTPd, using clock_gettime
> and then adjtimex() to correct for the calculated offset or freq
> adjustment. No extra interfaces are necessary, and PTPd is syncing the
> system time as accurately as it can. This is how the existing ptpd
> projects on the web seem to function.
>
> Now, with PTP hardware on the system, my understanding of what you're
> trying to enable with your patches is that the PTP hardware does the
> timestamping on both incoming and outgoing messages. PTPd then reads the
> pre-timestamped messages, calculates the offset and freq correction, and
> then feeds that back into the PTP hardware via your interface. No time
> correction is done at all by PTPd.

John,
What you describe here is only one of the use cases. If the hardware
has a single network port and operates as a PTP slave, it timestamps
the PTP packets that are sent and received and subsequently uses these
timestamps and the information it received from the master in the
packets to steer its clock to align it with the master clock. In such
a case the timestamping hardware and the clock hardware work together
closely and it seems to be okay to use the same interface to control
both the timestamping and the PTP clock.

But we have to consider other use cases, e.g.,

1) Boundary clocks:
We have more than one network port. One port operates as a slave
clock, our system gets time information via this port and steers its
PTP clock to align with the master clock. The other network ports of
our system operate as master clocks and redistribute the time
information we got from the master to other clocks on these networks.
In such a case we do timestamping on each of the network ports, but we
only have a single PTP clock. Each network port's timestamping
hardware uses the same hardware clock to generate time stamps.

2) Master clock:
We have one or more network ports. Our system has a really good clock
(ovenized quartz crystal, an atomic clock, a GPS timing receiver...)
and it distributes this time on the network. In such a case we do not
steer our clock based on the (packet) timestamps we get from our
timestamping unit. Instead, we directly drive our clock hardware with
a very stable frequency that we get from the OCXO or the atomic
clock... or we use one of the ancillary features of the PTP clock that
Richard mentioned to timestamp not network packets but a 1pps signal
and use these timestamps to steer the clock. Packet time stamping is
used to distribute the time to the slaves, but it is not part of the
control loop in this case.

So in the first case we have one PTP clock but several network packet
timestamping units, whereas in the second case the packet timestamping
is done but it is not part of the control loop that steers the clock.
Of course in most hardware implementations both the PTP clock and the
timestamping unit sit on the same chip and often use the same means of
communication to the cpu, e.g., the MDIO bus, but I think we need some
logical separation here.

Christian
