Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0LHUGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:06:45 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:36628 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753283Ab0LHUGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:06:44 -0500
Message-ID: <4CFFE5A9.4040407@bluewatersys.com>
Date: Thu, 09 Dec 2010 09:08:09 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Christian Glindkamp <christian.glindkamp@taskit.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Igor Plyatov <plyatov@gmail.com>,
        linux@arm.linux.org.uk, costa.antonior@gmail.com,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        linux@maxim.org.za, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] mach-at91: Support for gms board added
References: <1291732927-9429-1-git-send-email-plyatov@gmail.com> <4CFE90CA.9050004@bluewatersys.com> <4CFF47A0.8010208@atmel.com> <20101208145037.GA16435@taskit.de>
In-Reply-To: <20101208145037.GA16435@taskit.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 03:50 AM, Christian Glindkamp wrote:
> On 2010-12-08 09:53, Nicolas Ferre wrote:
>> Hi Igor,
>>
>> Le 07/12/2010 20:53, Ryan Mallon :
>>> On 12/08/2010 03:42 AM, Igor Plyatov wrote:
>>>> * The gms is a board from GeoSIG Ltd company.
>>>>   It is based on the Stamp9G20 module from Taskit company.
>>>> * This is a second version of the patch with adjustments according
>>>>   to comments from Ryan Mallon.
>>>> * This patch made for Linux 2.6.37-rc5.
>>
>> First thank you for submitting this board support.
>>
>>>> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
>>>> ---
>>
>> [..]
>>
>>> Couple more comments below.
>>> Looking at this a bit more closely, the Stamp9G20 is a system on module
>>> (SoM) board. The MACH_STAMP9G20 option supports the Stamp9G20 on
>>> taskits's evaluation board and the MACH_PCONTROL_G20 option supports it
>>> on the PControl carrier board. There is a reasonable amount of code
>>> replication in each of the board files for the UARTs, NAND, MMC, etc.
>>>
>>> Would it be better to have MACH_STAMPG20/board-stamp-9g20.c contain the
>>> core support for the Stamp9G20 module and then each of the carrier board
>>> files contain only the setup/devices found on the carrier board?
>>
>> I have exactly the same feeling as Ryan. We should make sure 
>> to factorize as much code as possible for maintenance reasons.
>>
>> If you need to distinguish between board features, you can 
>> pass information in system_rev as implemented in this 
>> board merging commit:
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a6e016f19d393fbe4e040bee8155b03b840fa689
>>
> 
> I don't think system_rev is such a good idea for carrier boards from
> different vendors. Somebody would have to control the assigned numbers.
> 
> This is what I would do:
> 1. Refactor board-stamp9g20.c have three board init functions:
> - portuxg20_board_init for PortuxG20 SBC (MACH_PORTUXG20)

I don't like the idea of having all of the carrier boards in the same
file as the SoM. Carrier boards may be developed by different people and
if there are a large number of them then the board files will start to
get quite big and confusing.

I think we need a standardised architecture for managing SoMs. A simple,
crude way would be to export the init functions from the SoM, i.e:
stam9g20_map_io and stamp9g20_board_init. Have the core SoM
functionality in those functions, for example in board-stamp9g20.c:

void __init stamp9g20_map_io(void)
{	
	/* Initialize processor: 18.432 MHz crystal */
	at91sam9260_initialize(18432000);

	/* DGBU on ttyS0. (Rx & Tx only) */
	at91_register_uart(0, 0, 0);

	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
	at91_register_uart(AT91SAM9260_ID_US0, 1, ATMEL_UART_CTS
			| ATMEL_UART_RTS | ATMEL_UART_DTR
			| ATMEL_UART_DSR | ATMEL_UART_DCD
			| ATMEL_UART_RI);

	/* set serial console to ttyS0 (ie, DBGU) */
	at91_set_serial_console(0);
}
EXPORT_SYMBOL(stamp9g20_map_io);

and then have the carrier specific initialisation in board-portuxg20.c:

static void __init portuxg20_map_io(void)
{
	stamp9g20_map_io();
		
	/* USART1 on ttyS2. (Rx, Tx, CTS, RTS) */
	at91_register_uart(AT91SAM9260_ID_US1, 2,
			ATMEL_UART_CTS | ATMEL_UART_RTS);

	/* USART2 on ttyS3. (Rx, Tx, CTS, RTS) */
	at91_register_uart(AT91SAM9260_ID_US2, 3,
			 ATMEL_UART_CTS | ATMEL_UART_RTS);

	/* USART4 on ttyS5. (Rx, Tx only) */
	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
	
	/* USART5 on ttyS6. (Rx, Tx only) */
	at91_register_uart(AT91SAM9260_ID_US5, 6, 0);
}

This reduces code reuse, and also means that if the carrier board has
some esoteric setup it can do its own initialisation rather than calling
stamp9g20_map_io. The downsides to this approach are the necessity of
having the exported functions and the relationship between the SoM and
the carrier board is not completely clear.

Maybe having additional macros similar to MACHINE_START for SoMs so that
we can have a machine_desc type struct for the SoM and can do things
like som->map_io()?

> - stamp9g20_board_init only containing the functions used on the
>   Stamp9G20 alone

Agreed.

> - stamp9g20evb_board_init calling stamp9g20_board_init and adding
>   functionality of the evaluation board (MACH_STAMP9G20)
>
> 2. Modify board-pcontrol-g20.c to use stamp9g20_board_init

Okay, I think we are both for the same approach :-).

> This would still duplicate the UART config (there is not much to share,
> only the DBGU would be configured on all boards), but share NAND, MMC,
> 1-wire. Everything else can't be shared as it is carrier board specific.
> 
> The gms board would then have to have its own machine number and call
> stamp9g20_board_init.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
