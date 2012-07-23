Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab2GWSw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:52:58 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52996 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab2GWSw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:52:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] acpi: fix pwr_btn_event_pending build error
Date: Mon, 23 Jul 2012 20:58:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120721214156.GA2515@linux.vnet.ibm.com> <201207221940.51764.rjw@sisk.pl> <20120722202843.GQ2435@linux.vnet.ibm.com>
In-Reply-To: <20120722202843.GQ2435@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207232058.41398.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 22, 2012, Paul E. McKenney wrote:
> On Sun, Jul 22, 2012 at 07:40:51PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, July 22, 2012, Paul E. McKenney wrote:
> > > On Sun, Jul 22, 2012 at 03:08:40AM +0300, Kirill A. Shutemov wrote:
> > > > On Sat, Jul 21, 2012 at 04:37:14PM -0700, Paul E. McKenney wrote:
> > > > > On Sun, Jul 22, 2012 at 12:52:43AM +0300, Kirill A. Shutemov wrote:
> > > > > > On Sat, Jul 21, 2012 at 02:41:56PM -0700, Paul E. McKenney wrote:
> > > > > > > Hello!
> > > > > > > 
> > > > > > > A recent build for KVM on x86 resulted in the following build error:
> > > > > > > 
> > > > > > > drivers/acpi/sleep.c:60:13: warning: ‘pwr_btn_event_pending’ defined but not
> > > > > > > +used [-Wunused-variable]
> > > > > > > 
> > > > > > > This patch silences this error.
> > > > > > > 
> > > > > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > > > 
> > > > > > > diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> > > > > > > index 8856102..18347aa 100644
> > > > > > > --- a/drivers/acpi/sleep.c
> > > > > > > +++ b/drivers/acpi/sleep.c
> > > > > > > @@ -57,7 +57,9 @@ MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
> > > > > > >  MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
> > > > > > >  
> > > > > > >  static u8 sleep_states[ACPI_S_STATE_COUNT];
> > > > > > > +#ifdef CONFIG_ACPI_SLEEP
> > > > > > >  static bool pwr_btn_event_pending;
> > > > > > > +#endif /* #ifdef CONFIG_ACPI_SLEEP */
> > > > > > 
> > > > > > __maybe_unused ?
> > > > > 
> > > > > Are the compiler and linker smart enough to get rid of the storage in
> > > > > case it really isn't used?  (Not that the storage for a bool is worth
> > > > > worrying about, but...)
> > > > 
> > > > GCC with optimization enabled will get rid of the storage even without
> > > > __maybe_unused.
> > > 
> > > OK, that should allow me to get rid of a few ifdefs, then!  For this one,
> > > please see below.
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > acpi: fix pwr_btn_event_pending build error
> > > 
> > > A recent build for KVM on x86 resulted in the following build error:
> > > 
> > > drivers/acpi/sleep.c:60:13: warning: ‘pwr_btn_event_pending’ defined but not
> > > +used [-Wunused-variable]
> > > 
> > > This patch silences this error.
> > > 
> > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > 
> > Well, I prefer the one below.
> 
> Works for me!

Cool. :-)

I'll resend it just in case there was some confusion somewhere.

Thanks,
Rafael


> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: ACPI / PM: Fix build warning in sleep.c for CONFIG_ACPI_SLEEP unset
> > 
> > If CONFIG_ACPI_SLEEP is unset, the compiler complains that
> > pwr_btn_event_pending is defined but not used.  To silence the
> > warning, move the definition of pwr_btn_event_pending under an
> > apprporiate #ifdef.
> > 
> > Reported-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/acpi/sleep.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux/drivers/acpi/sleep.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/sleep.c
> > +++ linux/drivers/acpi/sleep.c
> > @@ -57,7 +57,6 @@ MODULE_PARM_DESC(gts, "Enable evaluation
> >  MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
> >  
> >  static u8 sleep_states[ACPI_S_STATE_COUNT];
> > -static bool pwr_btn_event_pending;
> >  
> >  static void acpi_sleep_tts_switch(u32 acpi_state)
> >  {
> > @@ -110,6 +109,7 @@ static int acpi_sleep_prepare(u32 acpi_s
> >  
> >  #ifdef CONFIG_ACPI_SLEEP
> >  static u32 acpi_target_sleep_state = ACPI_STATE_S0;
> > +static bool pwr_btn_event_pending;
> >  
> >  /*
> >   * The ACPI specification wants us to save NVS memory regions during hibernation
> > 
> 
> 
> 

