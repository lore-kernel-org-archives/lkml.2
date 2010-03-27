Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0C0I1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 04:27:42 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:48551 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0C0I1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 04:27:38 -0400
Date: Sat, 27 Mar 2010 09:27:33 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
Message-ID: <20100327082733.GA4494@hardeman.nu>
Mail-Followup-To: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
References: <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
 <20100326112755.GB5387@hardeman.nu>
 <4BACC769.6020906@redhat.com>
 <20100326160150.GA28804@core.coreip.homeip.net>
 <4BACED6B.9030409@redhat.com>
 <9e4733911003261537s770a66c8v92ab7384fde34839@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e4733911003261537s770a66c8v92ab7384fde34839@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 06:37:41PM -0400, Jon Smirl wrote:
> On Fri, Mar 26, 2010 at 1:22 PM, Mauro Carvalho Chehab 
> <mchehab@redhat.com> wrote:
> > 2) create a read/write sysfs node that would indicate the number of 
> > event/keymaps
> > associated with a given IR. By writing a bigger number, it would create new devices.
> > By writing a smaller number, it will delete some maps. There's an issue though:
> > what criteria would be used to delete? The newly created ones?
> 
> This is normally handled a sysfs node on the core, something like
> 'adddev'. You echo '1' to this node and a new interface is created.
> 
> Each interface has a sysfs node, make a 'remove' attribute in it. Echo
> '1' to remove to make it disappear.
> 
> You have to implement the code behind these interfaces but this
> convention is used in other subsubsystems.
> 
> BTW - you're recreating everything the configfs interface did. it
> achieved the same results with mkdir/rmdir. I liked the configfs
> scheme since there are no obscure commands to learn. Everybody can
> make files and directories.

I've looked at your configfs interface, it was the inspiration for 
suggesting that each irrcv device should have more than one keymap with 
one input device for each keytable.

However, I don't agree that the configfs interface would somehow be more 
user-friendly than an ioctl based one. Getting the correct "scancode" 
(e.g, protocol, device, function values), finding a corresponding 
keycode (is it KEY_0, no wait, it's KEY_NUMERIC_0), etc are bigger 
hurdles than mkdir/rmdir/echo or calling a tool similar to input-utils 
which does the ioctl.

mount -t configfs blabla /somewhere (distros don't seem to mount 
configfs per default)
cd /somewhere/somewhere-else
mkdir something
echo gibberish1 > yada1
echo gibberish2 > yada2
echo gibberish3 > yada3

Doesn't seem all that much less obscure than the command line interface 
to an ioctl based interface:

ir-util load_keytable /usr/share/remotes/blah

or

ir-util load_keyentry "gibberish1,gibberish2 = gibberish3"

Assume the user provides an invalid (e.g. out-of-bounds value for the 
device field of a RC5 ir command) scancode. With the configfs approach 
the user will get a standard perror reply from echo/cat. With a 
dedicated tool the user can get a much more informative error message.

But in the end, the majority of users are going to use some GUI to do 
all of this anyway (and they'll only do it once)....start GUI, ask user 
to press all keys on remote one by one, provide them with a list of 
possible descriptions (i.e. input.h type keycodes) for each detected key 
on the remote (something like the keymapping interface most quake-like 
computer games provide).  Once done, save keymap. Load keymap at boot.  
Configfs or ioctl or sysfs or netlink or blorkfs is a detail which won't 
matter to those users.

-- 
David Härdeman
