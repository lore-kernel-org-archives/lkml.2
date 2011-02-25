Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1BYPWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:22:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42730 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab1BYPWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:22:41 -0500
MIME-Version: 1.0
In-Reply-To: <20110224231923.GB18233@yookeroo>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
 <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com>
 <20110223000759.GA26300@yookeroo> <4D653CF1.30009@caviumnetworks.com> <20110224231923.GB18233@yookeroo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Feb 2011 08:22:21 -0700
X-Google-Sender-Auth: dMKBem50mwVQbehumNNnMd-d5Mc
Message-ID: <AANLkTi=Oh0iu-d4n3rMLvXFH-DjS1mT3GgpoJyywjM=5@mail.gmail.com>
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
To: David Gibson <david@gibson.dropbear.id.au>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Ben Herrenschmidt, Rob Herring and Kevin Hilman]

On Thu, Feb 24, 2011 at 4:19 PM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> On Wed, Feb 23, 2011 at 08:59:29AM -0800, David Daney wrote:
>> On 02/22/2011 04:07 PM, David Gibson wrote:
>> >On Tue, Feb 22, 2011 at 12:57:46PM -0800, David Daney wrote:
>> >>Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> >>---
>> >>  arch/mips/cavium-octeon/.gitignore      |    2 +
>> >>  arch/mips/cavium-octeon/Makefile        |   13 ++
>> >>  arch/mips/cavium-octeon/octeon_3xxx.dts |  314 +++++++++++++++++++++++++++++++
>> >>  arch/mips/cavium-octeon/octeon_68xx.dts |   99 ++++++++++
>> >>  4 files changed, 428 insertions(+), 0 deletions(-)
>> >>  create mode 100644 arch/mips/cavium-octeon/.gitignore
>> >>  create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
>> >>  create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
>> >>
>> [...]
>>
>> >>+    };
>> >>+  };
>> >
>> >Uh.. where are the CPUs?
>> >
>>
>> The number and type of CPUs can be (and is) probed.  There is an
>> existing mechanism for the bootloader to communicate which CPUs
>> should be used.
>
> Hrm, ok.
>
> Grant,
>
> We've seen this now on both MIPS and ARM - dts files with no cpus, on
> the grounds that those can be runtime probed.  I guess it makes sense,
> although a dts without cpus looks very, very odd to me.  What are your
> thoughts on this?

Yeah, it looks odd, but you and I have been looking at device trees,
and .dts file specifically for a lot longer and so are probably a
little set in our ways.

Generally I've applied the argument that it's a good idea to populate
the /cpus node as an anchor for future things that might require it.
For example, a theoretical hypervisor which doesn't allow the guest
access to all the CPUs would use cpu nodes to tell the OS 'hands off'.
 Or possibly more likely, and AMP scenario where Linux would certainly
detect all the CPUs, but is supposed to leave some of them alone.  It
would also be an anchor for anything NUMA-like which is also
theoretical, but may become more likely in some of the larger ARM
designs that I've been hearing about.

For the same reason I've been recommending to SoC port authors to
populate the .dts will all the devices in the SoC, even for devices
that don't need any configuration data.  I2C and SPI busses are no
brainers because they need child nodes to describe the contents of the
bus, but there is no obvious configuration data for, say, an on chip
timer.  However, describing it in the tree still provides an anchor
for stuff like disabling devices that the OS should ignore for other
reasons, or for allowing other devices to hold a phandle reference to
it.

There is also the convenience factor of not needing to maintain a
table of platform_devices for each SoC if they are described in the
dt, but in the arm world the kernel still needs to support non-dt
board ports so it will have those tables regardless (unless an SoC
converts wholesale to dt).  It is valuable to share init code for both
dt and non-dt use cases.

Given that we've been very explicit that the device tree is for
describing things that aren't probable, the argument that it is not
necessary to populate the cpus node probably holds some water.  If
there are no special considerations (ie. disabled CPUs or NUMA) and
nothing holds a phandle to a specific cpu node, then it is probably
okay to omit.  In that case the lack of /cpus node would mean simply,
"detect the cpus", and /cpus could be populated to override the
detected behaviour.

Picking up on something David Daney said...
>> The number and type of CPUs can be (and is) probed.  There is an
>> existing mechanism for the bootloader to communicate which CPUs
>> should be used.

I do get a little nervous about this (the bootloader communication
bit).  For ARM, I had an argument with Nicolas Pitre about preserving
the existing ATAGs mechanism and adding DT on top vs. replacing ATAGs
entirely with DT.  I wanted to keep ATAGs, but Nicolas was concerned
about how to handle ambiguity about which data to use when the ATAGs
and DT disagree.  In hindsight Nicolas was 100% right and I'm glad he
pushed back.  The ARM DT support now detects if ATAGs or a .dtb were
passed at boot (one or the other), and it is *so* much cleaner.  All
configuration data lives in the same place and is manipulated in the
same way.  Plus it means that the dt usage model is the same for
multiple architectures, arm, powerpc and microblaze.

g.
