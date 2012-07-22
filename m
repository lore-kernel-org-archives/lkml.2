Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926Ab2GVEL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 00:11:28 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36375 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab2GVEL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 00:11:27 -0400
Date: Sat, 21 Jul 2012 21:10:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: fix pwr_btn_event_pending build error
Message-ID: <20120722041038.GN2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120721214156.GA2515@linux.vnet.ibm.com>
 <20120721215243.GA15362@shutemov.name>
 <20120721233714.GL2435@linux.vnet.ibm.com>
 <20120722000838.GA15798@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120722000838.GA15798@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072204-3534-0000-0000-00000AA8DDF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 03:08:40AM +0300, Kirill A. Shutemov wrote:
> On Sat, Jul 21, 2012 at 04:37:14PM -0700, Paul E. McKenney wrote:
> > On Sun, Jul 22, 2012 at 12:52:43AM +0300, Kirill A. Shutemov wrote:
> > > On Sat, Jul 21, 2012 at 02:41:56PM -0700, Paul E. McKenney wrote:
> > > > Hello!
> > > > 
> > > > A recent build for KVM on x86 resulted in the following build error:
> > > > 
> > > > drivers/acpi/sleep.c:60:13: warning: ‘pwr_btn_event_pending’ defined but not
> > > > +used [-Wunused-variable]
> > > > 
> > > > This patch silences this error.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > 
> > > > diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> > > > index 8856102..18347aa 100644
> > > > --- a/drivers/acpi/sleep.c
> > > > +++ b/drivers/acpi/sleep.c
> > > > @@ -57,7 +57,9 @@ MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
> > > >  MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
> > > >  
> > > >  static u8 sleep_states[ACPI_S_STATE_COUNT];
> > > > +#ifdef CONFIG_ACPI_SLEEP
> > > >  static bool pwr_btn_event_pending;
> > > > +#endif /* #ifdef CONFIG_ACPI_SLEEP */
> > > 
> > > __maybe_unused ?
> > 
> > Are the compiler and linker smart enough to get rid of the storage in
> > case it really isn't used?  (Not that the storage for a bool is worth
> > worrying about, but...)
> 
> GCC with optimization enabled will get rid of the storage even without
> __maybe_unused.

OK, that should allow me to get rid of a few ifdefs, then!  For this one,
please see below.

							Thanx, Paul

------------------------------------------------------------------------

acpi: fix pwr_btn_event_pending build error

A recent build for KVM on x86 resulted in the following build error:

drivers/acpi/sleep.c:60:13: warning: ‘pwr_btn_event_pending’ defined but not
+used [-Wunused-variable]

This patch silences this error.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>

diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 8856102..18347aa 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -57,7 +57,9 @@ MODULE_PARM_DESC(gts, "Enable evaluation of _GTS on suspend.");
 MODULE_PARM_DESC(bfs, "Enable evaluation of _BFS on resume".);
 
 static u8 sleep_states[ACPI_S_STATE_COUNT];
+#ifdef CONFIG_ACPI_SLEEP
 static bool pwr_btn_event_pending;
+#endif /* #ifdef CONFIG_ACPI_SLEEP */
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
 {

