Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2DIUsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:48:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:61507 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755727Ab2DIUsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <4F833CFC.9020809@wwwdotorg.org>
References: <20120409194514.8004.53204.stgit@dwillia2-linux.jf.intel.com>
	<20120409194857.8004.86352.stgit@dwillia2-linux.jf.intel.com>
	<4F833CFC.9020809@wwwdotorg.org>
Date: Mon, 9 Apr 2012 13:48:32 -0700
Message-ID: <CABE8wwtqUsgTd5cwJPu3MebuJUB0jHfpiA7LavFYn87kRhnDrw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] tegra, serial8250: add ->handle_break() uart_port op
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: gregkh@linuxfoundation.org, Sudhakar Mamillapalli <sudhakar@fb.com>,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        Grant Likely <grant.likely@secretlab.ca>, linux-serial@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 9, 2012 at 12:48 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 04/09/2012 01:48 PM, Dan Williams wrote:
>> The "KT" serial port has another use case for a "received break" quirk,
>> so before adding another special case to the 8250 core take this
>> opportunity to push such quirks out of the core and into a uart_port op.
>>
>> Stephen says:
>> "If the callback function is to no longer live in 8250.c itself,
>>  arch/arm/mach-tegra/devices.c isn't logically a good place to put it,
>>  and that file will be going away once we get rid of all the board files
>>  and move solely to device tree."
>>
>> ...so since 8250_pci.c houses all the quirks for pci serial devices this
>> quirk is similarly housed in of_serial.c.  Once the open firmware
>> conversion completes the infrastructure details (CONFIG_TEGRA_SERIAL,
>> include/linux/of_serial.h, and the export) can all be removed to make
>> this self contained to of_serial.c.
>
> This still seems much to invasive.

I agree that the arch/arm/mach-tegra/ and Kconfig touches are messy,
but those are also things that will just be deleted when Tegra
completes its transition to open firmware.

If you take those changes out of the equation this patch is actually
net-positive in terms deleting more lines than it adds.

 drivers/tty/serial/8250/8250.c |   34 +++-------------------------------
 drivers/tty/serial/of_serial.c |   25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 31 deletions(-)

> Again, what's wrong with simply keeping the quirk implementation where
> it is, and driving everything off the already-extant
> plat_serial8250_port.type == PORT_TEGRA flag?

Because Alan said to Sudhakar's new "break" quirk:

"This wants to be some kind of call back handled case not more stuff in
the core 8250.c which we are trying to drive all the special cases back
out of."

...and a certain Stephen Warren ;-) said in a comment:

" * FIXME: This needs to become a port specific callback once we have a
  * framework for this"

> I believe all that's required here is to enhance struct struct
> serial8250_config (and hence 8250.c's uart_config[] quirk table) to be
> able to set the quirk function pointers as well as all the other exiting
> quirked variables.

That does not provide the necessary amount of flexibility.  The "KT"
device is a good example it's a standard 8250 with a handle_break
quirk.  We could not express that if quirks were tied to
serial8250_config... outside of requiring a new type for every
variation of quirk.

--
Dan
