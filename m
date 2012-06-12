Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2FLUtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:49:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59884 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab2FLUtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:49:51 -0400
MIME-Version: 1.0
X-Originating-IP: [184.183.177.134]
Date: Tue, 12 Jun 2012 16:49:50 -0400
Message-ID: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com>
Subject: [question] x86/x86_64 boot process
From: Brandon Falk <bfalk@gamozolabs.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings. Please CC me on any responses as I do not subscribe to the list.

I'm currently working on a very very small boot loader. Currently it
uses BIOS int 0x13 to load up the 'setup' segments to 0x9000:0x0000. I
jump to this location, set up the kernel options, and then jump to
0x9020:0x0000. Everything goes great. However, I get the message 'No
setup signature found...'. I'm assuming this is due to not loading up
the protected-mode code. I'm slightly confused as to how the protected
mode code is to be loaded. As my 'bzImage' is 2.6MB, I would need to
raise the A20 line to possibly load this up. Does the kernel assist in
this process at all? Should I set up a code32_start routine for my
code to load up the kernel? Once I'm in protected mode, how will I
even access the medium that the kernel is loaded from without creating
a driver?

Currently the medium is a floppy image loaded in VMWare. It's a 64-bit
system. I'm just looking to be pointed in the right direction for the
next step (and if my current steps are valid for Protocol 2.10).

Here's the current code (the code is manually overwritten onto the
bzImage, however only the code... the headers are left intact on the
bzImage):

[org  0x7C00]
[bits 16]

%define koff(x) es:(x-0x7C00)

section .text

start:
xor bx, bx
xor cx, cx

mov ah, 0x02
mov al, 0x1D
mov cl, 0x01
xor dh, dh

push 0x9000
pop  es
mov  bx, 0x0000 ; read to 9000:0000
int  0x13
jc   short halt

jmp 0x9000:(setup-0x7C00)

setup:
mov word [koff(root_flags)], 0
mov word [koff(vid_mode)],   0xFFFF
mov word [koff(root_dev)],   0

mov dword [koff(realmode_switch)], 0
mov byte  [koff(type_of_loader)],  0xFF
mov byte  [koff(loadflags)],       0b10000001

mov dword [koff(ramdisk_image)], 0
mov dword [koff(ramdisk_size)],  0

mov word [koff(heap_end_ptr)], (0x5000 - 0x200)

mov dword [koff(cmd_line_ptr)], cmdline

mov dword [koff(hw_subarch)], 0

mov dword [koff(setup_data)], 0

cli
mov bx, 0x9000
mov ss, bx
mov ds, bx
mov es, bx
mov fs, bx
mov gs, bx

mov sp, 0x5000

jmp 0x9020:0

halt:
hlt
jmp short halt

cmdline: db 'auto', 0

times 0x1f1-($-$$) db 0

setup_sects: db 0x1D ;   ~ read
root_flags:  dw 0    ; x ~ modify
syssize:     dd 0    ;   ~ read
ram_size:    dw 0    ; x ~ internal
vid_mode:    dw 0    ; *   modify
root_dev:    dw 0    ; x ~ modify
boot_flag:   dw 0    ; * ~ read

; sector 2

jump:             dw 0 ;   ~ read
header:           dd 0 ;   ~ read
version:          dw 0 ;   ~ read
realmode_switch:  dd 0 ; o ~ modify
start_sys_reg:    dw 0 ; x ~ read
kernel_version:   dw 0 ;   ~ read
type_of_loader:   db 0 ; * ~ write
loadflags:        db 0 ; *   modify
setup_move_size:  dw 0 ; x ~ modify
code32_start:     dd 0 ; o ~ modify
ramdisk_image:    dd 0 ; *   write
ramdisk_size:     dd 0 ; *   write
bootsect_kludge:  dd 0 ; x ~ internal
heap_end_ptr:     dw 0 ; *   write
ext_loader_ver:   db 0 ; o ~ write
ext_loader_type:  db 0 ; o ~ write
cmd_line_ptr:     dd 0 ; *   write
ramdisk_max:      dd 0 ;   ~ read
kernel_alignment: dd 0 ;   ~ read
relocabl_kernel:  db 0 ;   ~ read
min_alignment:    db 0 ;   ~ read

db 0
db 0

cmdline_size:     dd 0 ;   ~ read
hw_subarch:       dd 0 ; o ~ write
hw_subarch_data:  dq 0 ; o ~ write
payload_offset:   dd 0 ;   ~ read
payload_length:   dd 0 ;   ~ read
setup_data:       dq 0 ; s ~ write
pref_address:     dq 0 ;   ~ read
init_size:        dd 0 ;   ~ read

-Brandon
