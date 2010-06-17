Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960Ab0FQAlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 20:41:12 -0400
Received: from [159.226.40.154] ([159.226.40.154]:39546 "EHLO mail.loongson.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab0FQAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 20:41:06 -0400
From: qiaochong <qiaochong@loongson.cn>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jsimmons@infradead.org,
       qiaochong@loongson.cn
Subject: [PATCH 0/2] resend:kernel will die on some platform when switch from vga mode to framebuffer mode
Date: Thu, 17 Jun 2010 08:41:23 +0800
Message-Id: <1276735285-7045-1-git-send-email-qiaochong@loongson.cn>
X-Mailer: git-send-email 1.7.0.3.254.g4503b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two patchs I sent can not pass checkpatch, so now resend it.


I found this bug  on 2.6.27. The bug still exist on kernel above 2.6.27.
I test patch "fix vc->vc_origin on take_over_console" on 2.6.27 on loongson development board,which use sis V2 graphic card.

all patches can be applied on from 2.6.33 to 2.6.35-rc2.

detail description as bellow:


https://bugzilla.kernel.org/show_bug.cgi?id=16155

There is a bug on framebufer and vt,kernel will die on some platform when
switch from vga mode to framebuffer mode.
The reason of this bug is that bind_con_driver reset vc->vc_origin to (unsigned
long)vc->vc_screenbuf.

1.The description bellow is my test on mips platform.
On this platform vga memory is at 0xb00b8000 (0xb0000000 is pci memory
0)£¬kernel memory is from 0x80000000~0x8fffffff.

on include/asm-mips/vga.h

#define VGA_MAP_MEM(x, s)   (0xffffffffb0000000L + (unsigned long)(x))

on drivers/video/console/vgacon.c
static const char *vgacon_startup(void)
{
...
    vga_vram_base = VGA_MAP_MEM(vga_vram_base, vga_vram_size);
    vga_vram_end = vga_vram_base + vga_vram_size;
...
}

Here vga_vram_base will be 0xb00b8000.

static int vgacon_set_origin(struct vc_data *c)
{
    if (vga_is_gfx ||   /* We don't play origin tricks in graphic modes */
        (console_blanked && !vga_palette_blanked))  /* Nor we write to blanked
screens */
        return 0;

/*---------here set vc_origin,which is not releated to  vc->vc_screenbuf here.
---------*/

    c->vc_origin = c->vc_visible_origin = vga_vram_base;
    vga_set_mem_top(c);
    vga_rolled_over = 0;
    return 1;
}

Here vc_origin will be 0xb00b8000.


./drivers/char/vt.c

static void set_origin(struct vc_data *vc)
{
    WARN_CONSOLE_UNLOCKED();

    if (!CON_IS_VISIBLE(vc) ||
        !vc->vc_sw->con_set_origin ||
        !vc->vc_sw->con_set_origin(vc))
        vc->vc_origin = (unsigned long)vc->vc_screenbuf;
    vc->vc_visible_origin = vc->vc_origin;

/*---------here set vc_src_end ---------*/

    vc->vc_scr_end = vc->vc_origin + vc->vc_screenbuf_size;
    vc->vc_pos = vc->vc_origin + vc->vc_size_row * vc->vc_y + 2 * vc->vc_x;
}

Here vc.vc_scr_end will be 0xb00b8fa0.

So before framebuffer take over console,vc=0x81081340
vc.vc_origin=0xb00b8000,vc.vc_scr_end=0xb00b8fa0.

When kernel boot,framebuffer take over vga's console:
backtrace like this:

[<80430640>] vc_do_resize+0x2d4/0x4e4
[<80430874>] vc_resize+0x24/0x3c
[<804413ac>] fbcon_init+0x358/0x4d8
[<80430148>] visual_init+0x198/0x224
             bind_con_driver
[<80432fa4>] take_over_console+0x508/0x6e8
[<80440400>] fbcon_takeover+0x88/0xf4
[<80446bac>] fbcon_event_notify+0x46c/0x99c
[<8025f060>] notifier_call_chain+0x64/0xbc
[<8025f3f4>] __blocking_notifier_call_chain+0x5c/0x98
[<8025f444>] blocking_notifier_call_chain+0x14/0x2c
[<80439eec>] register_framebuffer+0x1e8/0x218
[<8020ff1c>] sisfb_probe+0x2140/0x224c
[<80414a00>] pci_device_probe+0x70/0xb4
[<80483874>] driver_probe_device+0x174/0x2b0
[<80483aa4>] __driver_attach+0x54/0x98
[<804824a8>] bus_for_each_dev+0x60/0xb0
[<80482df4>] bus_add_driver+0xc8/0x280
[<8048409c>] driver_register+0xb4/0x178
[<80414728>] __pci_register_driver+0x58/0xb8
[<8070e460>] sisfb_init+0x89c/0x8e4
[<80219350>] __kprobes_text_end+0x68/0x1c4
[<806f8c0c>] kernel_init+0xa8/0x134
[<8021b9e4>] kernel_thread_helper+0x1c/0x24

static int bind_con_driver(const struct consw *csw, int first, int last,
               int deflt)
{
...
/* notice that here change vc_origin to vc_screenbuf,wrong! */
 vc->vc_origin = (unsigned long)vc->vc_screenbuf;
 visual_init(vc, i, 0);
...
}

for  vgacon in my test:
vc=0x81081340 origin=0xb00b8000,end=0xb00b8fa0
after here change to
vc=0x81081340,origin=0x810814a0,end=0xb00b8fa0
then go to see vc_do_resize,visual_init will call it.



static int vc_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
        struct vc_data *vc, unsigned int cols, unsigned int lines)
{
    unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
    unsigned int old_cols, old_rows, old_row_size, old_screen_size;
    unsigned int new_cols, new_rows, new_row_size, new_screen_size;
    unsigned int end, user;
...
        end = (old_rows > new_rows) ? old_origin +
            (old_row_size * new_rows) :
            vc->vc_scr_end;

...
/*
here for vgacon:
old_origin=810814a0,end=b00b8fa0,vc->vc_origin=810814a0
the code bellow will copy memory from 0x810814a0 to 0xb00b8fa0,
this will cover kernel code,kernel died here.
*/

    while (old_origin < end) {

        scr_memcpyw((unsigned short *) new_origin,
                (unsigned short *) old_origin, rlth);
        if (rrem)
            scr_memsetw((void *)(new_origin + rlth),
                    vc->vc_video_erase_char, rrem);
        old_origin += old_row_size;
        new_origin += new_row_size;
    }

...
}
the code bellow will above copy memory from 0x810814a0 to 0xb00b8fa0,this will
cover kernel code,kernel died here.


The test I have done is on mips 32bit kernel.
On 64bit kernel,kernel will run well.
When I look close at the code,I found that variable end is defined as
integer,but old_origin is unsigned long.
On 64bit kernel long is 64bit,int is 32bit,so old_origin is large than end,so
kernel jump over the dead code.
So I say:

2.The kernel code may be not very clean,
In function vc_do_resize,old_origin, new_origin, new_scr_end is unsigned long
type,but end is int type.
According include/linux/console_struct.h,they all should be unsigned long.


struct vc_data {
    unsigned short  vc_num;         /* Console number */
    unsigned int    vc_cols;        /* [#] Console size */
    unsigned int    vc_rows;
    unsigned int    vc_size_row;        /* Bytes per row */
    unsigned int    vc_scan_lines;      /* # of scan lines */
    unsigned long   vc_origin;      /* [!] Start of real screen */
    unsigned long   vc_scr_end;     /* [!] End of real screen */
    unsigned long   vc_visible_origin;  /* [!] Top of visible window */
    unsigned int    vc_top, vc_bottom;  /* Scrolling region */
    const struct consw *vc_sw;
    unsigned short  *vc_screenbuf;
...
}


That's all.



qiaochong (2):
  fix vc->vc_origin on take_over_console.
  Variable end on vc_do_resize should be unsigned long.

 drivers/char/vt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

