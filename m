Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2GDNqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:46:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56375 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2GDNqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:46:36 -0400
MIME-Version: 1.0
Date: Wed, 4 Jul 2012 15:46:35 +0200
Message-ID: <CAN+gG=GnMX8Gu6w9za2QrjoVrmORncFgq-+hhmHvxtOPEB=nDw@mail.gmail.com>
Subject: Hid over I2C and ACPI interaction
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>,
        JJ Ding <jj_ding@emc.com.tw>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I'm the co-author and the maintainer of the hid-multitouch driver. To
support even more devices, I started the implementation of the HID
over I2C protocol specification which is introduced by Win8. I'm quite
comfortable with the hid and the I2C part, but I'm blocked with the
interaction with the ACPI for the pnp part.

I wanted to have your advice/help on this problem. I've add in the
recipients list the maintainers of i2c and ACPI, sorry for the noise
if you don't feel concerned about this.

So, let's go deeper in the problem ;-)
Microsoft's spec asks the OEM to fill the ACPI DSDT to provide the
following scope in the ASL layout:

>>>>>>>>> begin of ASL
Scope (\_SB) {
//--------------------
//  General Purpose I/O, ports 0...127
//--------------------

Device(HIDI2C_DEVICE1) {
    Name(_ADR,0)
    Name (_HID, "MSFT1234”)
    Name (_CID, "PNP0C50")
    Name (_UID, 3)

    Method(_CRS, 0x0, NotSerialized)
    {
        Name (RBUF, ResourceTemplate ()
        {
        // Address 0x07 on I2C-X (OEM selects this address)
       //IHV SPECIFIC I2C3 = I2C Controller; TGD0 = GPIO Controller;
        I2CSerialBus (0x07, ControllerInitiated,
100000,AddressingMode7Bit, "\\_SB.I2C3",,,,)
        GpioInt(Level, ActiveLow, Exclusive, PullUp, 0, "\\_SB. TGD0",
0 , ResourceConsumer, , ) {40}
        })
     Return(RBUF)
     }

     Method(_DSM, 0x4, NotSerialized)
     {
        // BreakPoint
        Store ("Method _DSM begin", Debug)

        // DSM UUID
        switch(ToBuffer(Arg0))
        {		
            // ACPI DSM UUID for HIDI2C
            case(ToUUID("3CDFF6F7-4267-4555-AD05-B30A3D8938DE"))
            {
                 // DSM function which returns the HID Descriptor
Address (skipped)
            }

            default
            {
                // No other GUIDs supported
                Return(Buffer(One) { 0x00 })
            }
        }
    }
}
<<<<<<<<< end of ASL

Summary:
- a HID over I2C device has to present the Compatibility ID "PNP0C50"
- in the _CRS block, the address, the adapter and the gpioInt are
defined (or referenced)
- it presents a Device Specific Method (_DSM) which returns the HID
Descriptor register address. This register is our entry point for
retrieving the information about our hid device (so it's mandatory to
obtain it).

Where am I:
- I've written a first layer on top of i2c that retrieves the hid
register (currently the address 0x0001 is hardcoded), then get the
report desccriptors and the input events, and forward all this stuff
to the hid layer.
- It's working with a custom emulated HID over i2c touchpad, while
waiting for the one a manufacturer should send to me.
- The detection and the addition to the adapter is done by adding the
address in the lists and the name through the i2c "->detect" callback
(which is not very good, because I don't have the interrupt line
there).
- I've written a first acpi implementation that rely on the
DEVICE_ACPI_HANDLE macro to get the ACPI handle of the device (if
available).
- I'm not able to do some tests with the ACPI, as I don't know how to
implement this DSDT on my computer (I'm missing the I2C part), and the
manufacturer returned the mainboard with the right DSDT to the OEM.

My questions:
- will the current acpi implementation handle I2C devices?
- it seems to me that the .archdata field is left blank during the i2c
device initialization in all paths I've seen. Is that true?
- who puts the name int the struct i2c_board_info? (for hot-plugged
i2c devices).

- finally, what is the best way of handling ACPI for those I2C devices:
  1) everything is fine, I should have the ACPI handle in .archdata.
  2) someone has to implement the handling of I2C in the pnpACPI layer
(by adding I2CSerialBus handling and creating there the i2c slave).
  3) I should create an acpi driver which handles "PNP0C50" and which
creates the i2c slaves.

The thing is that I'm not very comfortable with solutions 2 and 3
(i2c_new_device tells that it must not be called during
arch_initcall(), how can I get the adapter, shall I blacklist in
pnpacpi "PNP0C50" ...), so gentlemen, I'm waiting for your advice.

Many thanks,
Benjamin
