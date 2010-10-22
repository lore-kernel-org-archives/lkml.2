Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab0JVQsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:48:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:39421 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755449Ab0JVQsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:48:14 -0400
Date: Fri, 22 Oct 2010 18:47:48 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA bugfixes
Message-ID: <20101022164748.GA20440@comet.dominikbrodowski.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Anca Emanuel <anca.emanuel@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-pcmcia@lists.infradead.org
References: <AANLkTi=M3fpiqii_0qoZawRiZfw1=WZPOhLgKesjFaTu@mail.gmail.com>
 <AANLkTinm8okUNs8P_iFfnaG0d5g2DGTpphTVC766ofmm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinm8okUNs8P_iFfnaG0d5g2DGTpphTVC766ofmm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 08:21:15AM -0700, Linus Torvalds wrote:
> On Fri, Oct 22, 2010 at 12:35 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> >  CC [M]  drivers/net/wireless/hostap/hostap_cs.o
> > drivers/staging/comedi/drivers/ni_daq_700.c: In function ‘dio700_config’:
> > drivers/staging/comedi/drivers/ni_daq_700.c:499: error: ‘win_req_t’
> > undeclared (first use in this function)
> 
> Looks like the PCMCIA win_req_t fixup missed a driver or two.
> 
> Dominik?
> 
> And if somebody else wants to help out, look at commit cdb138080b78
> ("pcmcia: do not use win_req_t when calling pcmcia_request_window()")
> for guidance about what it is all about. That shows other drivers
> being converted.
> 
> Anyway, in this case, it looks like the problem is literally that
> _unused_ declaration of 'win_req_t req'. Just remove that line. Does
> it compile and work then?

Yes, that line is superfluous -- sorry about that. Could you please pull
from

git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git urgent

for the two attached patches, please?

Dominik Brodowski (2):
      pcmcia: IOCARD is also required for using IRQs
      pcmcia: fix ni_daq_700 compilation

 drivers/pcmcia/pcmcia_resource.c            |    4 +++-
 drivers/staging/comedi/drivers/ni_daq_700.c |    1 -
 include/pcmcia/ds.h                         |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

Thanks,
	Dominik


From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Fri, 22 Oct 2010 18:39:23 +0200
Subject: [PATCH] pcmcia: fix ni_daq_700 compilation

Reported-by: Anca Emanuel <anca.emanuel@gmail.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index fc772a8..6b7372e 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -496,7 +496,6 @@ static int dio700_pcmcia_config_loop(struct pcmcia_device *p_dev,
 
 static void dio700_config(struct pcmcia_device *link)
 {
-	win_req_t req;
 	int ret;
 
 	printk(KERN_INFO "ni_daq_700:  cs-config\n");


From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Fri, 22 Oct 2010 08:46:36 +0200
Subject: [PATCH] pcmcia: IOCARD is also required for using IRQs

Dave Hinds pointed out to me that 37979e1546a7 will break b43 and
ray_cs, as IOCARD is not -- as the name would suggest -- only needed
for cards using IO ports. Instead, as it re-deines several pins, it
is also required for using interrupts.

Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index a9af0d7..0bdda5b 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -514,7 +514,9 @@ int pcmcia_enable_device(struct pcmcia_device *p_dev)
 	}
 
 	/* Pick memory or I/O card, DMA mode, interrupt */
-	if (p_dev->_io)
+	if (p_dev->_io || flags & CONF_ENABLE_IRQ)
+		flags |= CONF_ENABLE_IOCARD;
+	if (flags & CONF_ENABLE_IOCARD)
 		s->socket.flags |= SS_IOCARD;
 	if (flags & CONF_ENABLE_SPKR) {
 		s->socket.flags |= SS_SPKR_ENA;
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index d830c87..8479b66 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -259,6 +259,8 @@ void pcmcia_disable_device(struct pcmcia_device *p_dev);
 #define CONF_ENABLE_SPKR        0x0002
 #define CONF_ENABLE_PULSE_IRQ   0x0004
 #define CONF_ENABLE_ESR         0x0008
+#define CONF_ENABLE_IOCARD	0x0010 /* auto-enabled if IO resources or IRQ
+					* (CONF_ENABLE_IRQ) in use */
 
 /* flags used by pcmcia_loop_config() autoconfiguration */
 #define CONF_AUTO_CHECK_VCC	0x0100 /* check for matching Vcc? */
