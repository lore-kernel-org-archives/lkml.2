Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0DNNNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:13:34 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:37506 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0DNNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=JpTDZbiFwHmJtby9M7uWazGnk7gf24obSqKenMzInmHvbqVar1UL1HPo90vML3TkJP
         HYRtruH0eGheOI/keluyFZo3M0HhmT8vSvR7BH/iB91VKrKubJNiZG9jZEl0/5NbyOgH
         gRz7VUoKG3Le/olgYu4lV5NKVtBGn8Dzzbq1c=
Date: Wed, 14 Apr 2010 15:13:24 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [acpi:battery?] kernel oops on boot
Message-ID: <20100414131324.GA6598@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414095750.GA3304@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm seeing a similar bug on my notebook (Asus F3Sa) with current git.
-rc4 does not work, while -rc3 does work.

The error (at least in my case) is a division by zero in
acpi_ex_insert_into_field.
Disassembly near the faulty instruction (div %esi) looks like this:

0x000000000001cbee <+205>:  74 09          je     0x1cbf9 <acpi_ex_insert_into_field+216>        
0x000000000001cbf0 <+207>:  40 88 f1       mov    %sil,%cl                               
0x000000000001cbf3 <+210>:  49 d3 e5       shl    %cl,%r13                               
0x000000000001cbf6 <+213>:  49 f7 d5       not    %r13                                   
0x000000000001cbf9 <+216>:  0f b6 4b 24    movzbl 0x24(%rbx),%ecx
0x000000000001cbfd <+220>:  40 0f b6 f6    movzbl %sil,%esi
0x000000000001cc01 <+224>:  49 83 c9 ff    or $0xffffffffffffffff,%r9
0x000000000001cc05 <+228>:  8b 7b 18       mov    0x18(%rbx),%edi
0x000000000001cc08 <+231>:  49 d3 e1       shl    %cl,%r9
0x000000000001cc0b <+234>:  8d 7c 3e ff    lea -0x1(%rsi,%rdi,1),%edi
0x000000000001cc0f <+238>:  31 d2          xor    %edx,%edx
0x000000000001cc11 <+240>:  89 f8          mov    %edi,%eax
0x000000000001cc13 <+242>:  4d 21 e9       and    %r13,%r9
0x000000000001cc16 <+245>:  f7 f6          div    %esi
0x000000000001cc18 <+247>:  41 bb 01 00 00 00      mov $0x1,%r11d
0x000000000001cc1e <+253>:  89 45 b4       mov    %eax,-0x4c(%rbp)
0x000000000001cc21 <+256>:  31 d2          xor    %edx,%edx
0x000000000001cc23 <+258>:  8d 04 0f       lea (%rdi,%rcx,1),%eax
0x000000000001cc26 <+261>:  0f b6 4b 0f    movzbl 0xf(%rbx),%ecx

Register dump confirms that ESI is 0. The div seems to be generated for
ACPI_ROUND_UP_TO:

865             datum_count = ACPI_ROUND_UP_TO(obj_desc->common_field.bit_length,
   0x0000000000000d11 <+220>:   movzbl %sil,%esi
   0x0000000000000d19 <+228>:   mov    0x18(%rbx),%edi
   0x0000000000000d1f <+234>:   lea    -0x1(%rsi,%rdi,1),%edi
   0x0000000000000d23 <+238>:   xor    %edx,%edx
   0x0000000000000d25 <+240>:   mov    %edi,%eax
   0x0000000000000d2a <+245>:   div    %esi
   0x0000000000000d32 <+253>:   mov    %eax,-0x4c(%rbp)

(recompiled with DEBUG_INFO)

Stack trace:
acpi_ex_insert_into_field
acpi_ex_write_data_to_field
acpi_ex_store_object_to_node
acpi_ex_store
acpi_ex_opcode_1A_1T_1R
acpi_ds_exec_end_op
acpi_ps_parse_loop
acpi_ps_parse_aml
acpi_ps_execute_method
acpi_ns_evaluate
acpi_evaluate_object
acpi_battery_update [battery]
acpi_battery_add [battery]
acpi_device_probe
driver_probe_device
bus_for_each_dev
driver_attach
bus_add_driver
driver_register
acpi_bus_register_driver
acpi_battery_init_async [battery]


Compiler is:
$ gcc --version
gcc (Debian 4.4.3-7) 4.4.3

Luca
