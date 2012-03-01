Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966262Ab2CANUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:20:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966222Ab2CANUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:20:03 -0500
Message-ID: <4F4F776B.90609@redhat.com>
Date: Thu, 01 Mar 2012 10:19:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4E1F91.9080705@redhat.com> <20120229134556.GG21224@aftab> <4F4E3059.7040004@redhat.com> <20120229144054.GH21224@aftab> <3908561D78D1C84285E8C5FCA982C28F040115@ORSMSX104.amr.corp.intel.com> <20120229171626.GJ21224@aftab> <3908561D78D1C84285E8C5FCA982C28F040193@ORSMSX104.amr.corp.intel.com> <20120301112949.GA32410@aftab>
In-Reply-To: <20120301112949.GA32410@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 01-03-2012 08:29, Borislav Petkov escreveu:
> On Wed, Feb 29, 2012 at 05:33:51PM +0000, Luck, Tony wrote:
>>> IOW, we want to assume that cores 0, 1, 2 ... k-1 are on node 0; k, k+1
>>> ... 2k-1 belong to node 1, etc., where k is the number of cores on a
>>> socket and thus we have a regular core enumeration on the box.
>>
>> Sounds dubious:
>>
>> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
>> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
>> Booting Node   0, Processors  #16 #17 #18 #19 #20 #21 #22 #23 Ok.
>> Booting Node   1, Processors  #24 #25 #26 #27 #28 #29 #30 #31
>> Brought up 32 CPUs
>>
>> Now those are logical cpu numbers, and we brought up the first HT
>> thread on each core first, and then came around for a 2nd pass
>> bringing up the other HT thread.  This order is determined by
>> how the BIOS lists the cpus (and in this case it seems to be
>> doing so according to recommendations) - so here our core numbers
>> will match what you said. But the BIOS could do something
>> strange and list logical cpus alternating between sockets. In
>> which case cores 0, 2, 4, 6 ... would be on node 0, and cores
>> 1, 3, 5, 7, ... on node 1.
> 
> Ok, the example above actually confirms my fear that you won't be always
> able to map back to a physical socket from the CPU number. So, we'll
> need the ->socketid field which is the physical processor ID we get from
> CPUID leafs.
> 
> Then, mapping back the socketid to the silkscreen labels on the boards
> should be easy because on the boxes I have here, they go like this: P0,
> P1, ..., where P0 is the socket containing the BSP, P1 is the second
> socket etc. I'm guessing this is similar on Intel boards...?

The mapping from socket id to silkscreen label is motherboard-dependent.
I did some tests with a few different machines:

[root@dell-pe1950-05 ~]# dmidecode | grep -i "Processor Information" -A10
Processor Information
	Socket Designation: CPU1
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: F6 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 6
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
--
Processor Information
	Socket Designation: CPU2
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: F6 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 6
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)

[root@hp-dl580g5-01 ~]# dmidecode | grep -i "Processor Information" -A10
Processor Information
	Socket Designation: Proc 1
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: Intel
	ID: FB 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
--
Processor Information
	Socket Designation: Proc 2
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: Intel
	ID: FB 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
--
Processor Information
	Socket Designation: Proc 3
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: Intel
	ID: FB 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
--
Processor Information
	Socket Designation: Proc 4
	Type: Central Processor
	Family: Xeon MP
	Manufacturer: Intel
	ID: FB 06 00 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 15, Stepping 11
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)

dmidecode | grep -i "Processor Information" -A10
Processor Information
	Socket Designation: CPU 1
	Type: Central Processor
	Family: Pentium M
	Manufacturer: Intel            
	ID: A4 06 01 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 26, Stepping 4
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
--
Processor Information
	Socket Designation: CPU 2
	Type: Central Processor
	Family: Pentium M
	Manufacturer: Intel            
	ID: A4 06 01 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 26, Stepping 4
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)

[root@hp-bl260cg5-01 ~]# dmidecode | grep "Processor Information" -A10
Processor Information
	Socket Designation: Proc 1
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: 76 06 01 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 23, Stepping 6
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
--
Processor Information
	Socket Designation: Proc 2
	Type: Central Processor
	Family: Xeon
	Manufacturer: Intel
	ID: 00 00 00 00 00 00 00 00
	Signature: Type 0, Family 0, Model 0, Stepping 0
	Flags: None
	Version: Not Specified
	Voltage: 1.1 V
	External Clock: 200 MHz

On all the above, the socket label starts on 1, but I bet we'll find cases
where it start from 0.


Regards,
Mauro
