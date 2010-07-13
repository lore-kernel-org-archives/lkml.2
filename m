Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0GMUlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:41:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32587 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0GMUlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:41:07 -0400
Message-ID: <4C3CCE05.4090505@kernel.org>
Date: Tue, 13 Jul 2010 13:35:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <4C3B40F3.6070009@kernel.org> <4C3CA5A9.6000607@cs.helsinki.fi>
In-Reply-To: <4C3CA5A9.6000607@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C3CCF02.0050,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 10:43 AM, Pekka Enberg wrote:
> Hi Yingahai,
> 
> Yinghai Lu wrote:
>> On 07/12/2010 08:47 AM, H. Peter Anvin wrote:
>>> On 07/12/2010 01:58 AM, Pekka Enberg wrote:
>>>> Hi Yinghai,
>>>>
>>>> Yinghai Lu wrote:
>>>>> Analyze "console=uart8250,io,0x3f8,115200n8" in
>>>>> i386_start_kernel/x86_64_start_kernel,
>>>>> and call setup_early_serial8250_console() to init early serial
>>>>> console.
>>>>>
>>>>> only can handle io port kind of 8250. because mmio need ioremap.
>>>>>
>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>> What's the purpose of this patch? Does it make my early boot I/O patch
>>>> obsolete?
>>>>
>>>>             Pekka
>>> No, they're complementary.  Your patch serial-port enables the RM
>>> kernel, whereas Yinghai pushes the initialization earlier in the PM
>>> kernel.
>>
>> yes. cover more range.
>>
>> Can you consider to ask Pekka to anaylze "console=uart8250,io,
>> 0x3f8,115200n8" instead?
>>
>> it looks like we can remove "earlyprintk=ttyS0,115200", or
>> "earlyprintk=serial" etc.
>>
>> earlycon=uart8250 or console=uart8250 should be better than earlyprintk.
>> because it is shared between different archs already.
> 
> So just to clarify: I wasn't ignoring your comment here. I simply
> followed hpa's recommendation on which I also happen to agree with
> completely. ;-)

never mind.

following patch add that checking.

also you missed simple_guess_base(), your patch may have problem with baud rate reading.

                baud = simple_strtoull(arg + pos, &e, 0);
                if (baud == 0 || arg + pos == e)
                        baud = DEFAULT_BAUD;

	and your copied simple_strtoull does not calling simple_guess_base(), so base will 0.
	so you are always using DEFAULT_BAUD.

Thanks

Yinghai Lu


[PATCH] x86: make boot code to analyze console=uart8250 too

So we use console=uart8250,io,0x2f8,115200n all the way

Also add back simple_guess_base(), otherwise those simple_strtoull(,,0) are not
going to work.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/string.c |   22 ++++++++++++++++++
 arch/x86/boot/tty.c    |   59 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/boot/tty.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/tty.c
+++ linux-2.6/arch/x86/boot/tty.c
@@ -170,7 +170,7 @@ static void early_serial_init(int baud)
 	outb(c & ~DLAB, early_serial_base + LCR);
 }
 
-void console_init(void)
+static int parse_earlyprintk(void)
 {
 	int baud = DEFAULT_BAUD;
 	char arg[32];
@@ -208,6 +208,63 @@ void console_init(void)
 			baud = DEFAULT_BAUD;
 	}
 
+	return baud;
+}
+
+#define BASE_BAUD (1843200/16)
+static unsigned int probe_baud(int port)
+{
+	unsigned char lcr, dll, dlh;
+	unsigned int quot;
+
+	lcr = inb(port + LCR);
+	outb(lcr | DLAB, port + LCR);
+	dll = inb(port + DLL);
+	dlh = inb(port + DLH);
+	outb(lcr, port + LCR);
+	quot = (dlh << 8) | dll;
+
+	return BASE_BAUD / quot;
+}
+
+static int parse_console_uart8250(void)
+{
+	char optstr[64], *options;
+	int baud = DEFAULT_BAUD;
+
+	/*
+	 * console=uart8250,io,0x3f8,115200n8
+	 * need to make sure it is last one console !
+	 */
+	if (cmdline_find_option("console", optstr, sizeof optstr) <= 0)
+		return baud;
+
+	options = optstr;
+
+	if (!strncmp(options, "uart8250,io,", 12))
+		early_serial_base = simple_strtoull(options + 12, &options, 0);
+	else if (!strncmp(options, "uart,io,", 8))
+		early_serial_base = simple_strtoull(options + 8, &options, 0);
+	else
+		return baud;
+
+	if (options && (options[0] == ','))
+		baud = simple_strtoull(options + 1, &options, 0);
+	else
+		baud = probe_baud(early_serial_base);
+
+	return baud;
+}
+
+void console_init(void)
+{
+	int baud;
+
+	baud = parse_earlyprintk();
+
+	if (!early_serial_base)
+		baud = parse_console_uart8250();
+
 	if (early_serial_base != 0)
 		early_serial_init(baud);
 }
Index: linux-2.6/arch/x86/boot/string.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/string.c
+++ linux-2.6/arch/x86/boot/string.c
@@ -68,10 +68,32 @@ unsigned int atou(const char *s)
 /* Works only for digits and letters, but small and fast */
 #define TOLOWER(x) ((x) | 0x20)
 
+static unsigned int simple_guess_base(const char *cp)
+{
+	if (cp[0] == '0') {
+		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
+			return 16;
+		else
+			return 8;
+	} else {
+		return 10;
+	}
+}
+
+/**
+ * simple_strtoull - convert a string to an unsigned long long
+ * @cp: The start of the string
+ * @endp: A pointer to the end of the parsed string will be placed here
+ * @base: The number base to use
+ */
+
 unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
 {
 	unsigned long long result = 0;
 
+	if (!base)
+		base = simple_guess_base(cp);
+
 	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
 		cp += 2;
 



