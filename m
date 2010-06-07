Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0FGMpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:45:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:39569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab0FGMpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:45:53 -0400
Message-ID: <4C0CE9FC.60905@suse.cz>
Date: Mon, 07 Jun 2010 14:45:48 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig qconf: port to QT4
References: <1275846668-17863-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
In-Reply-To: <1275846668-17863-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.6.2010 19:51, Alexander Stein wrote:
> A straight forward port to QT4 using qt3to4 and compiling against
>   qt3support
> 
> * rewritten makefile rules to use qmake based qt setup which is hopefully
>   portable enough
> * ConfigInfoView::menu has to be renamed as QT4 moc strips struct from
>   struct menu and creates a name conflict

I've only very little experience with Qt 3 or 4. The patch basically
changes most QSomeClass to Q3SomeClass, which is the Qt3-compatible
wrapper around QSomeClass. Now is it possible to still support Qt3? E.g.
have a header file that #defines Q3SomeClass back to QSomeClass and does
similar with the Qt headers, would that be possible? I know that Qt4 has
be there for five years already, but if the cost of keeping support for
old userspace is not too hight, I would try it.

BTW, after applying your patch, make xconfig starts ok, but clicking in
the main menu does nothing, and if I close the close button, it does not
exit, but stops reacting to any input (but it still handles window
resize). The qt3 version would display the "Save changes?" dialog here.

Michal

> 
> Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
> ---
>  scripts/kconfig/Makefile |   44 ++++---------
>  scripts/kconfig/qconf.cc |  163 +++++++++++++++++++++++----------------------
>  scripts/kconfig/qconf.h  |   61 ++++++-----------
>  3 files changed, 116 insertions(+), 152 deletions(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 7ea649d..01f5a1f 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -232,42 +232,22 @@ $(obj)/.tmp_qtcheck: $(src)/Makefile
>  
>  # QT needs some extra effort...
>  $(obj)/.tmp_qtcheck:
> -	@set -e; echo "  CHECK   qt"; dir=""; pkg=""; \
> -	pkg-config --exists qt 2> /dev/null && pkg=qt; \
> -	pkg-config --exists qt-mt 2> /dev/null && pkg=qt-mt; \
> -	if [ -n "$$pkg" ]; then \
> -	  cflags="\$$(shell pkg-config $$pkg --cflags)"; \
> -	  libs="\$$(shell pkg-config $$pkg --libs)"; \
> -	  moc="\$$(shell pkg-config $$pkg --variable=prefix)/bin/moc"; \
> -	  dir="$$(pkg-config $$pkg --variable=prefix)"; \
> -	else \
> -	  for d in $$QTDIR /usr/share/qt* /usr/lib/qt*; do \
> -	    if [ -f $$d/include/qconfig.h ]; then dir=$$d; break; fi; \
> -	  done; \
> -	  if [ -z "$$dir" ]; then \
> +	@set -e; echo "  CHECK   qt"; \
> +	qmake=$(shell which qmake); \
> +	echo $$qmake; \
> +	if [ -z $$qmake ]; then \
>  	    echo "*"; \
> -	    echo "* Unable to find the QT3 installation. Please make sure that"; \
> -	    echo "* the QT3 development package is correctly installed and"; \
> -	    echo "* either install pkg-config or set the QTDIR environment"; \
> -	    echo "* variable to the correct location."; \
> +	    echo "* Unable to find the QT4 tool qmake. Please make sure that"; \
> +	    echo "* the QT4 development package is correctly installed."; \
>  	    echo "*"; \
>  	    false; \
> -	  fi; \
> -	  libpath=$$dir/lib; lib=qt; osdir=""; \
> -	  $(HOSTCXX) -print-multi-os-directory > /dev/null 2>&1 && \
> -	    osdir=x$$($(HOSTCXX) -print-multi-os-directory); \
> -	  test -d $$libpath/$$osdir && libpath=$$libpath/$$osdir; \
> -	  test -f $$libpath/libqt-mt.so && lib=qt-mt; \
> -	  cflags="-I$$dir/include"; \
> -	  libs="-L$$libpath -Wl,-rpath,$$libpath -l$$lib"; \
> -	  moc="$$dir/bin/moc"; \
> -	fi; \
> -	if [ ! -x $$dir/bin/moc -a -x /usr/bin/moc ]; then \
> -	  echo "*"; \
> -	  echo "* Unable to find $$dir/bin/moc, using /usr/bin/moc instead."; \
> -	  echo "*"; \
> -	  moc="/usr/bin/moc"; \
>  	fi; \
> +	headerpath="\$$(shell $$qmake -query QT_INSTALL_HEADERS)"; \
> +	libpath="\$$(shell $$qmake -query QT_INSTALL_LIBS)"; \
> +	binpath="\$$(shell $$qmake -query QT_INSTALL_BINS)"; \
> +	cflags="-I$$headerpath -I$$headerpath/QtCore -I$$headerpath/QtGui -I$$headerpath/Qt3Support -DQT3_SUPPORT"; \
> +	libs="-L$$libpath -Wl,-rpath,$$libpath -lQtCore -lQtGui -lQt3Support"; \
> +	moc="$$binpath/moc"; \
>  	echo "KC_QT_CFLAGS=$$cflags" > $@; \
>  	echo "KC_QT_LIBS=$$libs" >> $@; \
>  	echo "KC_QT_MOC=$$moc" >> $@
> diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
> index 00c5150..184e080 100644
> --- a/scripts/kconfig/qconf.cc
> +++ b/scripts/kconfig/qconf.cc
> @@ -3,32 +3,33 @@
>   * Released under the terms of the GNU GPL v2.0.
>   */
>  
> -#include <qapplication.h>
> -#include <qmainwindow.h>
> -#include <qdesktopwidget.h>
> -#include <qtoolbar.h>
> -#include <qlayout.h>
> -#include <qvbox.h>
> -#include <qsplitter.h>
> -#include <qlistview.h>
> -#include <qtextbrowser.h>
> -#include <qlineedit.h>
> -#include <qlabel.h>
> -#include <qpushbutton.h>
> -#include <qmenubar.h>
> -#include <qmessagebox.h>
> -#include <qaction.h>
> -#include <qheader.h>
> -#include <qfiledialog.h>
> -#include <qdragobject.h>
> -#include <qregexp.h>
> +#include <QApplication>
> +#include <Q3MainWindow>
> +#include <QDesktopWidget>
> +#include <Q3ToolBar>
> +#include <QLayout>
> +#include <Q3VBox>
> +#include <QSplitter>
> +#include <Q3ListView>
> +#include <Q3TextBrowser>
> +#include <QLineEdit>
> +#include <QLabel>
> +#include <QPushButton>
> +#include <QMenuBar>
> +#include <QMessageBox>
> +#include <Q3Action>
> +#include <Q3Header>
> +#include <Q3FileDialog>
> +#include <Q3DragObject>
> +#include <QRegExp>
> +#include <QKeyEvent>
> +#include <Q3PopupMenu>
>  
>  #include <stdlib.h>
>  
>  #include "lkc.h"
>  #include "qconf.h"
>  
> -#include "qconf.moc"
>  #include "images.c"
>  
>  #ifdef _
> @@ -39,7 +40,7 @@
>  static QApplication *configApp;
>  static ConfigSettings *configSettings;
>  
> -QAction *ConfigMainWindow::saveAction;
> +Q3Action *ConfigMainWindow::saveAction;
>  
>  static inline QString qgettext(const char* str)
>  {
> @@ -54,9 +55,9 @@ static inline QString qgettext(const QString& str)
>  /**
>   * Reads a list of integer values from the application settings.
>   */
> -QValueList<int> ConfigSettings::readSizes(const QString& key, bool *ok)
> +Q3ValueList<int> ConfigSettings::readSizes(const QString& key, bool *ok)
>  {
> -	QValueList<int> result;
> +	Q3ValueList<int> result;
>  	QStringList entryList = readListEntry(key, ok);
>  	if (ok) {
>  		QStringList::Iterator it;
> @@ -70,10 +71,10 @@ QValueList<int> ConfigSettings::readSizes(const QString& key, bool *ok)
>  /**
>   * Writes a list of integer values to the application settings.
>   */
> -bool ConfigSettings::writeSizes(const QString& key, const QValueList<int>& value)
> +bool ConfigSettings::writeSizes(const QString& key, const Q3ValueList<int>& value)
>  {
>  	QStringList stringList;
> -	QValueList<int>::ConstIterator it;
> +	Q3ValueList<int>::ConstIterator it;
>  
>  	for (it = value.begin(); it != value.end(); ++it)
>  		stringList.push_back(QString::number(*it));
> @@ -422,7 +423,7 @@ void ConfigList::updateList(ConfigItem* item)
>  	if (!rootEntry) {
>  		if (mode != listMode)
>  			goto update;
> -		QListViewItemIterator it(this);
> +		Q3ListViewItemIterator it(this);
>  		ConfigItem* item;
>  
>  		for (; it.current(); ++it) {
> @@ -553,7 +554,7 @@ void ConfigList::setParentMenu(void)
>  		return;
>  	setRootMenu(menu_get_parent_menu(rootEntry->parent));
>  
> -	QListViewItemIterator it(this);
> +	Q3ListViewItemIterator it(this);
>  	for (; (item = (ConfigItem*)it.current()); it++) {
>  		if (item->menu == oldroot) {
>  			setCurrentItem(item);
> @@ -635,7 +636,7 @@ void ConfigList::updateMenuList(P* parent, struct menu* menu)
>  
>  void ConfigList::keyPressEvent(QKeyEvent* ev)
>  {
> -	QListViewItem* i = currentItem();
> +	Q3ListViewItem* i = currentItem();
>  	ConfigItem* item;
>  	struct menu *menu;
>  	enum prop_type type;
> @@ -801,10 +802,10 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
>  {
>  	if (e->y() <= header()->geometry().bottom()) {
>  		if (!headerPopup) {
> -			QAction *action;
> +			Q3Action *action;
>  
> -			headerPopup = new QPopupMenu(this);
> -			action = new QAction(NULL, _("Show Name"), 0, this);
> +			headerPopup = new Q3PopupMenu(this);
> +			action = new Q3Action(NULL, _("Show Name"), 0, this);
>  			  action->setToggleAction(TRUE);
>  			  connect(action, SIGNAL(toggled(bool)),
>  				  parent(), SLOT(setShowName(bool)));
> @@ -812,7 +813,7 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
>  				  action, SLOT(setOn(bool)));
>  			  action->setOn(showName);
>  			  action->addTo(headerPopup);
> -			action = new QAction(NULL, _("Show Range"), 0, this);
> +			action = new Q3Action(NULL, _("Show Range"), 0, this);
>  			  action->setToggleAction(TRUE);
>  			  connect(action, SIGNAL(toggled(bool)),
>  				  parent(), SLOT(setShowRange(bool)));
> @@ -820,7 +821,7 @@ void ConfigList::contextMenuEvent(QContextMenuEvent *e)
>  				  action, SLOT(setOn(bool)));
>  			  action->setOn(showRange);
>  			  action->addTo(headerPopup);
> -			action = new QAction(NULL, _("Show Data"), 0, this);
> +			action = new Q3Action(NULL, _("Show Data"), 0, this);
>  			  action->setToggleAction(TRUE);
>  			  connect(action, SIGNAL(toggled(bool)),
>  				  parent(), SLOT(setShowData(bool)));
> @@ -898,7 +899,7 @@ void ConfigView::setShowData(bool b)
>  
>  void ConfigList::setAllOpen(bool open)
>  {
> -	QListViewItemIterator it(this);
> +	Q3ListViewItemIterator it(this);
>  
>  	for (; it.current(); it++)
>  		it.current()->setOpen(open);
> @@ -921,7 +922,7 @@ void ConfigView::updateListAll(void)
>  }
>  
>  ConfigInfoView::ConfigInfoView(QWidget* parent, const char *name)
> -	: Parent(parent, name), sym(0), menu(0)
> +	: Parent(parent, name), sym(0), _menu(0)
>  {
>  	if (name) {
>  		configSettings->beginGroup(name);
> @@ -944,7 +945,7 @@ void ConfigInfoView::setShowDebug(bool b)
>  {
>  	if (_showDebug != b) {
>  		_showDebug = b;
> -		if (menu)
> +		if (_menu)
>  			menuInfo();
>  		else if (sym)
>  			symbolInfo();
> @@ -954,11 +955,11 @@ void ConfigInfoView::setShowDebug(bool b)
>  
>  void ConfigInfoView::setInfo(struct menu *m)
>  {
> -	if (menu == m)
> +	if (_menu == m)
>  		return;
> -	menu = m;
> +	_menu = m;
>  	sym = NULL;
> -	if (!menu)
> +	if (!_menu)
>  		clear();
>  	else
>  		menuInfo();
> @@ -968,17 +969,17 @@ void ConfigInfoView::setSource(const QString& name)
>  {
>  	const char *p = name.latin1();
>  
> -	menu = NULL;
> +	_menu = NULL;
>  	sym = NULL;
>  
>  	switch (p[0]) {
>  	case 'm':
>  		struct menu *m;
>  
> -		if (sscanf(p, "m%p", &m) == 1 && menu != m) {
> -			menu = m;
> +		if (sscanf(p, "m%p", &m) == 1 && _menu != m) {
> +			_menu = m;
>  			menuInfo();
> -			emit menuSelected(menu);
> +			emit menuSelected(_menu);
>  		}
>  		break;
>  	case 's':
> @@ -1013,11 +1014,11 @@ void ConfigInfoView::menuInfo(void)
>  	struct symbol* sym;
>  	QString head, debug, help;
>  
> -	sym = menu->sym;
> +	sym = _menu->sym;
>  	if (sym) {
> -		if (menu->prompt) {
> +		if (_menu->prompt) {
>  			head += "<big><b>";
> -			head += print_filter(_(menu->prompt->text));
> +			head += print_filter(_(_menu->prompt->text));
>  			head += "</b></big>";
>  			if (sym->name) {
>  				head += " (";
> @@ -1043,23 +1044,23 @@ void ConfigInfoView::menuInfo(void)
>  			debug = debug_info(sym);
>  
>  		struct gstr help_gstr = str_new();
> -		menu_get_ext_help(menu, &help_gstr);
> +		menu_get_ext_help(_menu, &help_gstr);
>  		help = print_filter(str_get(&help_gstr));
>  		str_free(&help_gstr);
> -	} else if (menu->prompt) {
> +	} else if (_menu->prompt) {
>  		head += "<big><b>";
> -		head += print_filter(_(menu->prompt->text));
> +		head += print_filter(_(_menu->prompt->text));
>  		head += "</b></big><br><br>";
>  		if (showDebug()) {
> -			if (menu->prompt->visible.expr) {
> +			if (_menu->prompt->visible.expr) {
>  				debug += "&nbsp;&nbsp;dep: ";
> -				expr_print(menu->prompt->visible.expr, expr_print_help, &debug, E_NONE);
> +				expr_print(_menu->prompt->visible.expr, expr_print_help, &debug, E_NONE);
>  				debug += "<br><br>";
>  			}
>  		}
>  	}
>  	if (showDebug())
> -		debug += QString().sprintf("defined at %s:%d<br><br>", menu->file->name, menu->lineno);
> +		debug += QString().sprintf("defined at %s:%d<br><br>", _menu->file->name, _menu->lineno);
>  
>  	setText(head + debug + help);
>  }
> @@ -1162,10 +1163,10 @@ void ConfigInfoView::expr_print_help(void *data, struct symbol *sym, const char
>  		*text += str2;
>  }
>  
> -QPopupMenu* ConfigInfoView::createPopupMenu(const QPoint& pos)
> +Q3PopupMenu* ConfigInfoView::createPopupMenu(const QPoint& pos)
>  {
> -	QPopupMenu* popup = Parent::createPopupMenu(pos);
> -	QAction* action = new QAction(NULL, _("Show Debug Info"), 0, popup);
> +	Q3PopupMenu* popup = Parent::createPopupMenu(pos);
> +	Q3Action* action = new Q3Action(NULL, _("Show Debug Info"), 0, popup);
>  	  action->setToggleAction(TRUE);
>  	  connect(action, SIGNAL(toggled(bool)), SLOT(setShowDebug(bool)));
>  	  connect(this, SIGNAL(showDebugChanged(bool)), action, SLOT(setOn(bool)));
> @@ -1222,7 +1223,7 @@ ConfigSearchWindow::ConfigSearchWindow(ConfigMainWindow* parent, const char *nam
>  			y = configSettings->readNumEntry("/window y", 0, &ok);
>  		if (ok)
>  			move(x, y);
> -		QValueList<int> sizes = configSettings->readSizes("/split", &ok);
> +		Q3ValueList<int> sizes = configSettings->readSizes("/split", &ok);
>  		if (ok)
>  			split->setSizes(sizes);
>  		configSettings->endGroup();
> @@ -1309,60 +1310,60 @@ ConfigMainWindow::ConfigMainWindow(void)
>  	configList->setFocus();
>  
>  	menu = menuBar();
> -	toolBar = new QToolBar("Tools", this);
> +	toolBar = new Q3ToolBar("Tools", this);
>  
> -	backAction = new QAction("Back", QPixmap(xpm_back), _("Back"), 0, this);
> +	backAction = new Q3Action("Back", QPixmap(xpm_back), _("Back"), 0, this);
>  	  connect(backAction, SIGNAL(activated()), SLOT(goBack()));
>  	  backAction->setEnabled(FALSE);
> -	QAction *quitAction = new QAction("Quit", _("&Quit"), Qt::CTRL + Qt::Key_Q, this);
> +	Q3Action *quitAction = new Q3Action("Quit", _("&Quit"), Qt::CTRL + Qt::Key_Q, this);
>  	  connect(quitAction, SIGNAL(activated()), SLOT(close()));
> -	QAction *loadAction = new QAction("Load", QPixmap(xpm_load), _("&Load"), Qt::CTRL + Qt::Key_L, this);
> +	Q3Action *loadAction = new Q3Action("Load", QPixmap(xpm_load), _("&Load"), Qt::CTRL + Qt::Key_L, this);
>  	  connect(loadAction, SIGNAL(activated()), SLOT(loadConfig()));
> -	saveAction = new QAction("Save", QPixmap(xpm_save), _("&Save"), Qt::CTRL + Qt::Key_S, this);
> +	saveAction = new Q3Action("Save", QPixmap(xpm_save), _("&Save"), Qt::CTRL + Qt::Key_S, this);
>  	  connect(saveAction, SIGNAL(activated()), SLOT(saveConfig()));
>  	conf_set_changed_callback(conf_changed);
>  	// Set saveAction's initial state
>  	conf_changed();
> -	QAction *saveAsAction = new QAction("Save As...", _("Save &As..."), 0, this);
> +	Q3Action *saveAsAction = new Q3Action("Save As...", _("Save &As..."), 0, this);
>  	  connect(saveAsAction, SIGNAL(activated()), SLOT(saveConfigAs()));
> -	QAction *searchAction = new QAction("Find", _("&Find"), Qt::CTRL + Qt::Key_F, this);
> +	Q3Action *searchAction = new Q3Action("Find", _("&Find"), Qt::CTRL + Qt::Key_F, this);
>  	  connect(searchAction, SIGNAL(activated()), SLOT(searchConfig()));
> -	QAction *singleViewAction = new QAction("Single View", QPixmap(xpm_single_view), _("Single View"), 0, this);
> +	Q3Action *singleViewAction = new Q3Action("Single View", QPixmap(xpm_single_view), _("Single View"), 0, this);
>  	  connect(singleViewAction, SIGNAL(activated()), SLOT(showSingleView()));
> -	QAction *splitViewAction = new QAction("Split View", QPixmap(xpm_split_view), _("Split View"), 0, this);
> +	Q3Action *splitViewAction = new Q3Action("Split View", QPixmap(xpm_split_view), _("Split View"), 0, this);
>  	  connect(splitViewAction, SIGNAL(activated()), SLOT(showSplitView()));
> -	QAction *fullViewAction = new QAction("Full View", QPixmap(xpm_tree_view), _("Full View"), 0, this);
> +	Q3Action *fullViewAction = new Q3Action("Full View", QPixmap(xpm_tree_view), _("Full View"), 0, this);
>  	  connect(fullViewAction, SIGNAL(activated()), SLOT(showFullView()));
>  
> -	QAction *showNameAction = new QAction(NULL, _("Show Name"), 0, this);
> +	Q3Action *showNameAction = new Q3Action(NULL, _("Show Name"), 0, this);
>  	  showNameAction->setToggleAction(TRUE);
>  	  connect(showNameAction, SIGNAL(toggled(bool)), configView, SLOT(setShowName(bool)));
>  	  connect(configView, SIGNAL(showNameChanged(bool)), showNameAction, SLOT(setOn(bool)));
>  	  showNameAction->setOn(configView->showName());
> -	QAction *showRangeAction = new QAction(NULL, _("Show Range"), 0, this);
> +	Q3Action *showRangeAction = new Q3Action(NULL, _("Show Range"), 0, this);
>  	  showRangeAction->setToggleAction(TRUE);
>  	  connect(showRangeAction, SIGNAL(toggled(bool)), configView, SLOT(setShowRange(bool)));
>  	  connect(configView, SIGNAL(showRangeChanged(bool)), showRangeAction, SLOT(setOn(bool)));
>  	  showRangeAction->setOn(configList->showRange);
> -	QAction *showDataAction = new QAction(NULL, _("Show Data"), 0, this);
> +	Q3Action *showDataAction = new Q3Action(NULL, _("Show Data"), 0, this);
>  	  showDataAction->setToggleAction(TRUE);
>  	  connect(showDataAction, SIGNAL(toggled(bool)), configView, SLOT(setShowData(bool)));
>  	  connect(configView, SIGNAL(showDataChanged(bool)), showDataAction, SLOT(setOn(bool)));
>  	  showDataAction->setOn(configList->showData);
> -	QAction *showAllAction = new QAction(NULL, _("Show All Options"), 0, this);
> +	Q3Action *showAllAction = new Q3Action(NULL, _("Show All Options"), 0, this);
>  	  showAllAction->setToggleAction(TRUE);
>  	  connect(showAllAction, SIGNAL(toggled(bool)), configView, SLOT(setShowAll(bool)));
>  	  connect(showAllAction, SIGNAL(toggled(bool)), menuView, SLOT(setShowAll(bool)));
>  	  showAllAction->setOn(configList->showAll);
> -	QAction *showDebugAction = new QAction(NULL, _("Show Debug Info"), 0, this);
> +	Q3Action *showDebugAction = new Q3Action(NULL, _("Show Debug Info"), 0, this);
>  	  showDebugAction->setToggleAction(TRUE);
>  	  connect(showDebugAction, SIGNAL(toggled(bool)), helpText, SLOT(setShowDebug(bool)));
>  	  connect(helpText, SIGNAL(showDebugChanged(bool)), showDebugAction, SLOT(setOn(bool)));
>  	  showDebugAction->setOn(helpText->showDebug());
>  
> -	QAction *showIntroAction = new QAction(NULL, _("Introduction"), 0, this);
> +	Q3Action *showIntroAction = new Q3Action(NULL, _("Introduction"), 0, this);
>  	  connect(showIntroAction, SIGNAL(activated()), SLOT(showIntro()));
> -	QAction *showAboutAction = new QAction(NULL, _("About"), 0, this);
> +	Q3Action *showAboutAction = new Q3Action(NULL, _("About"), 0, this);
>  	  connect(showAboutAction, SIGNAL(activated()), SLOT(showAbout()));
>  
>  	// init tool bar
> @@ -1376,7 +1377,7 @@ ConfigMainWindow::ConfigMainWindow(void)
>  	fullViewAction->addTo(toolBar);
>  
>  	// create config menu
> -	QPopupMenu* config = new QPopupMenu(this);
> +	Q3PopupMenu* config = new Q3PopupMenu(this);
>  	menu->insertItem(_("&File"), config);
>  	loadAction->addTo(config);
>  	saveAction->addTo(config);
> @@ -1385,12 +1386,12 @@ ConfigMainWindow::ConfigMainWindow(void)
>  	quitAction->addTo(config);
>  
>  	// create edit menu
> -	QPopupMenu* editMenu = new QPopupMenu(this);
> +	Q3PopupMenu* editMenu = new Q3PopupMenu(this);
>  	menu->insertItem(_("&Edit"), editMenu);
>  	searchAction->addTo(editMenu);
>  
>  	// create options menu
> -	QPopupMenu* optionMenu = new QPopupMenu(this);
> +	Q3PopupMenu* optionMenu = new Q3PopupMenu(this);
>  	menu->insertItem(_("&Option"), optionMenu);
>  	showNameAction->addTo(optionMenu);
>  	showRangeAction->addTo(optionMenu);
> @@ -1400,7 +1401,7 @@ ConfigMainWindow::ConfigMainWindow(void)
>  	showDebugAction->addTo(optionMenu);
>  
>  	// create help menu
> -	QPopupMenu* helpMenu = new QPopupMenu(this);
> +	Q3PopupMenu* helpMenu = new Q3PopupMenu(this);
>  	menu->insertSeparator();
>  	menu->insertItem(_("&Help"), helpMenu);
>  	showIntroAction->addTo(helpMenu);
> @@ -1435,7 +1436,7 @@ ConfigMainWindow::ConfigMainWindow(void)
>  		showSplitView();
>  
>  	// UI setup done, restore splitter positions
> -	QValueList<int> sizes = configSettings->readSizes("/split1", &ok);
> +	Q3ValueList<int> sizes = configSettings->readSizes("/split1", &ok);
>  	if (ok)
>  		split1->setSizes(sizes);
>  
> @@ -1446,7 +1447,7 @@ ConfigMainWindow::ConfigMainWindow(void)
>  
>  void ConfigMainWindow::loadConfig(void)
>  {
> -	QString s = QFileDialog::getOpenFileName(conf_get_configname(), NULL, this);
> +	QString s = Q3FileDialog::getOpenFileName(conf_get_configname(), NULL, this);
>  	if (s.isNull())
>  		return;
>  	if (conf_read(QFile::encodeName(s)))
> @@ -1462,7 +1463,7 @@ void ConfigMainWindow::saveConfig(void)
>  
>  void ConfigMainWindow::saveConfigAs(void)
>  {
> -	QString s = QFileDialog::getSaveFileName(conf_get_configname(), NULL, this);
> +	QString s = Q3FileDialog::getSaveFileName(conf_get_configname(), NULL, this);
>  	if (s.isNull())
>  		return;
>  	if (conf_write(QFile::encodeName(s)))
> @@ -1761,3 +1762,5 @@ int main(int ac, char** av)
>  
>  	return 0;
>  }
> +
> +#include "qconf.moc"
> diff --git a/scripts/kconfig/qconf.h b/scripts/kconfig/qconf.h
> index b3b5657..8c8abdc 100644
> --- a/scripts/kconfig/qconf.h
> +++ b/scripts/kconfig/qconf.h
> @@ -3,27 +3,8 @@
>   * Released under the terms of the GNU GPL v2.0.
>   */
>  
> -#include <qlistview.h>
> -#if QT_VERSION >= 300
> -#include <qsettings.h>
> -#else
> -class QSettings {
> -public:
> -	void beginGroup(const QString& group) { }
> -	void endGroup(void) { }
> -	bool readBoolEntry(const QString& key, bool def = FALSE, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return def; }
> -	int readNumEntry(const QString& key, int def = 0, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return def; }
> -	QString readEntry(const QString& key, const QString& def = QString::null, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return def; }
> -	QStringList readListEntry(const QString& key, bool* ok = 0) const
> -	{ if (ok) *ok = FALSE; return QStringList(); }
> -	template <class t>
> -	bool writeEntry(const QString& key, t value)
> -	{ return TRUE; }
> -};
> -#endif
> +#include <Q3ListView>
> +#include <QSettings>
>  
>  class ConfigView;
>  class ConfigList;
> @@ -34,8 +15,8 @@ class ConfigMainWindow;
>  
>  class ConfigSettings : public QSettings {
>  public:
> -	QValueList<int> readSizes(const QString& key, bool *ok);
> -	bool writeSizes(const QString& key, const QValueList<int>& value);
> +	Q3ValueList<int> readSizes(const QString& key, bool *ok);
> +	bool writeSizes(const QString& key, const Q3ValueList<int>& value);
>  };
>  
>  enum colIdx {
> @@ -45,9 +26,9 @@ enum listMode {
>  	singleMode, menuMode, symbolMode, fullMode, listMode
>  };
>  
> -class ConfigList : public QListView {
> +class ConfigList : public Q3ListView {
>  	Q_OBJECT
> -	typedef class QListView Parent;
> +	typedef class Q3ListView Parent;
>  public:
>  	ConfigList(ConfigView* p, const char *name = 0);
>  	void reinit(void);
> @@ -129,17 +110,17 @@ public:
>  	struct menu *rootEntry;
>  	QColorGroup disabledColorGroup;
>  	QColorGroup inactivedColorGroup;
> -	QPopupMenu* headerPopup;
> +	Q3PopupMenu* headerPopup;
>  
>  private:
>  	int colMap[colNr];
>  	int colRevMap[colNr];
>  };
>  
> -class ConfigItem : public QListViewItem {
> -	typedef class QListViewItem Parent;
> +class ConfigItem : public Q3ListViewItem {
> +	typedef class Q3ListViewItem Parent;
>  public:
> -	ConfigItem(QListView *parent, ConfigItem *after, struct menu *m, bool v)
> +	ConfigItem(Q3ListView *parent, ConfigItem *after, struct menu *m, bool v)
>  	: Parent(parent, after), menu(m), visible(v), goParent(false)
>  	{
>  		init();
> @@ -149,7 +130,7 @@ public:
>  	{
>  		init();
>  	}
> -	ConfigItem(QListView *parent, ConfigItem *after, bool v)
> +	ConfigItem(Q3ListView *parent, ConfigItem *after, bool v)
>  	: Parent(parent, after), menu(0), visible(v), goParent(true)
>  	{
>  		init();
> @@ -213,9 +194,9 @@ public:
>  	ConfigItem *item;
>  };
>  
> -class ConfigView : public QVBox {
> +class ConfigView : public Q3VBox {
>  	Q_OBJECT
> -	typedef class QVBox Parent;
> +	typedef class Q3VBox Parent;
>  public:
>  	ConfigView(QWidget* parent, const char *name = 0);
>  	~ConfigView(void);
> @@ -244,9 +225,9 @@ public:
>  	ConfigView* nextView;
>  };
>  
> -class ConfigInfoView : public QTextBrowser {
> +class ConfigInfoView : public Q3TextBrowser {
>  	Q_OBJECT
> -	typedef class QTextBrowser Parent;
> +	typedef class Q3TextBrowser Parent;
>  public:
>  	ConfigInfoView(QWidget* parent, const char *name = 0);
>  	bool showDebug(void) const { return _showDebug; }
> @@ -267,11 +248,11 @@ protected:
>  	QString debug_info(struct symbol *sym);
>  	static QString print_filter(const QString &str);
>  	static void expr_print_help(void *data, struct symbol *sym, const char *str);
> -	QPopupMenu* createPopupMenu(const QPoint& pos);
> +	Q3PopupMenu* createPopupMenu(const QPoint& pos);
>  	void contentsContextMenuEvent(QContextMenuEvent *e);
>  
>  	struct symbol *sym;
> -	struct menu *menu;
> +	struct menu *_menu;
>  	bool _showDebug;
>  };
>  
> @@ -295,10 +276,10 @@ protected:
>  	struct symbol **result;
>  };
>  
> -class ConfigMainWindow : public QMainWindow {
> +class ConfigMainWindow : public Q3MainWindow {
>  	Q_OBJECT
>  
> -	static QAction *saveAction;
> +	static Q3Action *saveAction;
>  	static void conf_changed(void);
>  public:
>  	ConfigMainWindow(void);
> @@ -327,8 +308,8 @@ protected:
>  	ConfigView *configView;
>  	ConfigList *configList;
>  	ConfigInfoView *helpText;
> -	QToolBar *toolBar;
> -	QAction *backAction;
> +	Q3ToolBar *toolBar;
> +	Q3Action *backAction;
>  	QSplitter* split1;
>  	QSplitter* split2;
>  };

